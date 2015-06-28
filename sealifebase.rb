require 'rubygems'
require 'sinatra'
require 'json'
require 'mysql2'
require 'redis'
require 'geolocater'
require "sinatra/multi_route"

class SLBApp < Sinatra::Application
  private
  register Sinatra::MultiRoute

  $use_caching = true
  $use_logging = true
  log_file_path = "/var/log/sealifebase/api.log"
  host = ENV['MYSQL_PORT_3306_TCP_ADDR']

  # Set up MySQL DB
  if host.to_s == ''
    $slbclient = Mysql2::Client.new(:host => "localhost",
                                :username => "root",
                                :database => "slbapp",
                                :reconnect => true)
  else
    # Connect to a MySQL server via a linked docker container
    $slbclient = Mysql2::Client.new(
                               :host => "sealifebase",
                               :port => ENV['MYSQL_PORT_3306_TCP_PORT'],
                               :password => ENV['MYSQL_ENV_MYSQL_ROOT_PASSWORD'],
                               :username => "root",
                               :database => "slbapp",
                               :reconnect => true)
  end

  # Set up Redis for caching
  $slbredis = Redis.new(:host => "slbredis",
                    :port => ENV['REDIS_PORT_6379_TCP_PORT'],
                    :timeout => 500,
                    :connect_timeout => 500)

  # before do
  #   puts '[Params]'
  #   p params
  # end

  # before do
  #   puts '[env]'
  #   p env
  # end


  class LogstashLogger < Rack::CommonLogger
    private

    ### FIXME UGH, duplicate this definition so it's available to the private class.
    def redis_exists(key)
      if !$use_caching
        return false
      else
        begin
          return $slbredis.exists(key)
        rescue
          return false
        end
      end
    end
    def redis_set(key, value)
      if $use_caching
        begin
          return $slbredis.set(key, value)
        rescue
          return nil
        end
      end
    end
    def redis_get(key)
      begin
        return $slbredis.get(key)
      rescue
        return nil
      end
    end


    def ip_anonymize(ip)
      begin
        ismatch = ip.match('127.0.0.1|localhost|::1')
        if ismatch.nil?
          if redis_exists(ip)
            out = JSON.parse(redis_get(ip))
          else
            res = Geolocater.geolocate_ip(ip)
            out = res.keep_if { |key, value| key.to_s.match(/city|country_name/) }
            redis_set(ip, JSON.generate(out))
          end
        else
          out = {"city" => "localhost", "country_name" => "localhost"}
        end
        return out
      rescue
        return ip
    #    return {"city" => "localhost", "country_name" => "localhost"}
      end
    end

    def log(env, status, header, began_at)
      now    = Time.now
      length = extract_content_length(header)
      logger = @logger || env['rack.errors']
      json = {
        '@timestamp' => now.utc.iso8601,
        '@ip' => ip_anonymize($ip),
        '@fields'      => {
#          'remoteadd'  => env['REMOTE_ADDR'],
#          'ipadd'      => $ip,
          'method'     => env['REQUEST_METHOD'],
          'path'       => env['PATH_INFO'],
          'httpver'    => env['HTTP_VERSION'],
          'useragent'  => env['HTTP_USER_AGENT'],
          'params'     => env['rack.request.query_hash'],
          'status'     => status.to_s[0..3],
          'size'       => length,
          'duration'   => now - began_at,
        }
      }

      logger.puts(json.to_json)
    end
  end

  configure do
    # enable :logging
    set :logging, $use_logging
    set :raise_errors, false
    set :show_exceptions, false

    file = File.new(log_file_path, 'a+')
    file.sync = true

    use LogstashLogger, file
  end


  not_found do
    halt 404, {'Content-Type' => 'application/json'}, JSON.generate({ 'error' => 'route not found' })
  end

  # error 400 do |err|
  #   halt 400, {'Content-Type' => 'application/json'}, JSON.generate({ 'error' => 'invalid request #{err}' })
  # end

  error 500 do
    halt 500, {'Content-Type' => 'application/json'}, JSON.generate({ 'error' => 'server error' })
  end

  before do
    headers "Content-Type" => "application/json; charset=utf8"
    headers "Access-Control-Allow-Methods" => "HEAD, GET"
    headers "Access-Control-Allow-Origin" => "*"
    cache_control :public, :must_revalidate, :max_age => 60
  end

  get '/' do
    redirect '/heartbeat'
  end

  get '/docs' do
    redirect 'http://docs.fishbaseapi.apiary.io'
  end

  get "/heartbeat/?" do
    $ip = request.ip
    return JSON.pretty_generate({
      "routes" => [
        "/docs",
        "/heartbeat",
        "/mysqlping",
        "/comnames?<params>",
        "/countref?<params>",
        "/country?<params>",
        "/diet?<params>",
        "/ecology?<params>",
        "/ecosystem?<params>",
        "/faoareas/:id?<params>",
        "/faoarref/:id?<params>",
        "/fecundity?<params>",
        "/fooditems?<params>",
        "/genera/:id?<params>",
        "/intrcase?<params>",
        "/maturity?<params>",
        "/morphdat?<params>",
        "/morphmet?<params>",
        "/occurrence?<params>",
        "/oxygen?<params>",
        "/popchar?<params>",
        "/popgrowth?<params>",
        "/poplf?<params>",
        "/popll?<params>",
        "/popqb?<params>",
        "/poplw?<params>",
        "/predats?<params>",
        "/ration?<params>",
        "/refrens?<params>",
        "/reproduc?<params>",
        "/species/:id?<params>",
        "/spawning?<params>",
        "/speed?<params>",
        "/stocks?<params>",
        "/swimming?<params>",
        "/synonyms?<params>",
        "/taxa?<params>"
      ]
    })
  end

  get '/mysqlping/?' do
    return JSON.pretty_generate({
      "mysql_server_up" => $slbclient.ping,
      "mysql_host" => $slbclient.query_options[:host]
    })
  end


  ## list endpoints alphabetically for easy search

  get '/comnames/?' do
    route_noid('comnames')
  end

  get '/country/?' do
    route_noid('country')
  end

  get '/countref/?' do
    route_noid('countref')
  end

  get '/diet/?' do
    route_noid('diet')
  end

  get '/ecology/?' do
    route_noid('ecology')
  end

  get '/ecosystem/?' do
    route_noid('ecosystem')
  end


  get '/faoareas/?:id?/?' do
    route('faoareas', 'AreaCode')
  end

  get '/faoarref/?:id?/?' do
    route('faoarref', 'AreaCode')
  end

  get '/fecundity/?' do
    route_noid('fecundity')
  end


  get '/fooditems/?' do
    route_noid('fooditems')
  end

  get '/genera/?:id?/?' do
    route('genera', 'GenCode')
  end

  get '/intrcase/?' do
    route_noid('intrcase')
  end

  get '/maturity/?' do
    route_noid('maturity')
  end

  get '/morphdat/?' do
    route_noid('morphdat')
  end

  get '/morphmet/?' do
    route_noid('morphdat')
  end

  get '/occurrence/?' do
    route_noid('occurrence')
  end


  get '/oxygen/?' do
    route_noid('oxygen')
  end

  get '/popchar/?' do
    route_noid('popchar')
  end

  get '/popgrowth/?' do
    route_noid('popgrowth')
  end

  get '/poplf/?' do
    route_noid('poplf')
  end

  get '/popll/?' do
    route_noid('popll')
  end

  get '/popqb/?' do
    route_noid('popqb')
  end

  get '/poplw/?' do
    route_noid('poplw')
  end

  get '/predats/?' do
    route_noid('predats')
  end

  get '/ration/?' do
    route_noid('ration')
  end

  get '/refrens/?' do
    route_noid('refrens')
  end

  get '/reproduc/?' do
    route_noid('reproduc')
  end

  get '/spawning/?' do
    route_noid('spawning')
  end

  get '/species/?:id?/?' do
    route('species', 'SpecCode')
  end

  get '/speed/?' do
    route_noid('speed')
  end

  get '/stocks/?' do
    route_noid('stocks')
  end


  get '/swimming/?' do
    route_noid('swimming')
  end

  get '/synonyms/?' do
    route_noid('synonyms')
  end





  get '/taxa/?' do
    key = rediskey('taxa', params)

    result = false
    if redis_exists(key)
      result = get_cached(key)
      if !result.nil?
        out = result['data']
        err = result['error']
        count = result['count']
        result = true
      end
    end

    if !result
      limit = params[:limit] || 10
      params.delete("limit")
      params.keep_if { |key, value| key.to_s.match(/[Gg]enus|[Ss]pecies/) }
      args = get_args(params, prefix=true)

      query = sprintf("
        SELECT s.SpecCode,s.Genus,s.Species,s.SpeciesRefNo,s.Author,s.FBname,s.SubFamily,s.FamCode,s.GenCode,s.SubGenCode,s.Remark,f.Family,f.Order,f.Class
          FROM species s
          INNER JOIN families f on s.FamCode = f.FamCode
          INNER JOIN genera g on s.GenCode = g.GenCode
          %s limit %d", args, limit)
      count = get_count('species', get_args(params, prefix=false))

      res = $slbclient.query(query, :as => :json)
      out = res.collect{ |row| row }
      err = get_error(out)
      store = {"count" => count, "error" => err, "data" => out}
      redis_set(key, JSON.generate(store))
    end

    if result.nil?
      halt not_found
    end

    data = { "count" => count, "returned" => out.length, "error" => err, "data" => out }
    return JSON.pretty_generate(data)
  end

  route :put, :post, :delete, :copy, :options, :trace, '/*' do
    halt 405
  end

  # helpers
  def route(table, var)
    $ip = request.ip
    key = rediskey(table, params)
    if redis_exists(key)
      obj = get_cached(key)
      if obj.nil?
        obj = get_new_ids(key, table, var, params)
      end
    else
      obj = get_new_ids(key, table, var, params)
    end
    return give_data(obj)
  end

  def route_noid(table)
    $ip = request.ip
    key = rediskey(table, params)
    if redis_exists(key)
      obj = get_cached(key)
      if obj.nil?
        obj = get_new_noids(key, table, params)
      end
    else
      obj = get_new_noids(key, table, params)
    end
    return give_data(obj)
  end

  def redis_set(key, value)
  	if $use_caching
      begin
        return $slbredis.set(key, value)
      rescue
        return nil
      end
  	end
  end

  def redis_get(key)
    begin
      return $slbredis.get(key)
    rescue
      return nil
    end
  end

  def redis_exists(key)
  	if !$use_caching
  		return false
  	else
      begin
        return $slbredis.exists(key)
      rescue
        return false
      end
  	end
  end

  def rediskey(table, x)
    [table, '_', x.collect{ |key, value| [key,value].join(':') }.join].join
  end

  def get_error(x)
    if x.length == 0
    	return { 'message' => 'no results found' }
    else
      return nil
    end
  end

  def get_args(x, prefix=false)
    if prefix
      res = x.collect{ |row| "s.%s = '%s'" % row }
    else
      res = x.collect{ |row| "%s = '%s'" % row }
    end
    if res.length == 0
      return ''
    else
      return "WHERE " + res.join(' AND ')
    end
  end

  def check_fields(table, fields)
    query = sprintf("SELECT * FROM %s limit 1", table)
    res = $slbclient.query(query, :as => :json)
    flexist = res.fields
    fields = fields.split(',')
    if fields.length == 1
      fields = fields[0]
    end
    if fields.length == 0
      fields = '*'
    end
    if fields == '*'
      return fields
    else
      if fields.class == Array
        fields = fields.collect{ |d|
          if flexist.include? d
            d
          else
            nil
          end
        }
        fields = fields.compact.join(',')
        return fields
      else
        return fields
      end
    end
  end

  def check_params(table, params)
    if params.length == 0
      return params
    else
      query = sprintf("SELECT * FROM %s limit 1", table)
      res = $slbclient.query(query, :as => :json)
      flexist = ["^", res.fields.join('$|^'), "$"].join('').downcase
      params = params.keep_if { |key, value| key.downcase.to_s.match(flexist) }
      return params
    end
  end

  def get_count(table, string)
    query = sprintf("SELECT count(*) as ct FROM %s %s", table, string)
    res = $slbclient.query(query, :as => :json)
    res.collect{ |row| row }[0]["ct"]
  end

  def give_data(obj)
    data = { "count" => obj['count'], "returned" => obj['data'].length, "error" => obj['error'], "data" => obj['data'] }
    return JSON.pretty_generate(data)
  end

  def get_cached(key)
    tmp = redis_get(key)
    if tmp.nil?
      return nil
    else
      return JSON.parse(tmp)
    end
  end

  def get_new_ids(key, table, matchfield, params)
    id = params[:id]

    limit = params[:limit] || '10'
    offset = params[:offset] || '0'
    check_class(limit, 'limit')
    check_class(offset, 'offset')
    limit = check_hang_equal(limit, '10')
    offset = check_hang_equal(offset, '0')
    check_max(limit, 5000)

    fields = params[:fields] || '*'
    params.delete("limit")
    params.delete("fields")

    fields = check_fields(table, fields)
    args = get_args(check_params(table, params))

    if id.nil?
      query = sprintf("SELECT %s FROM %s %s limit %d offset %d", fields, table, args, limit, offset)
      count = get_count(table, args)
    else
      query = sprintf("SELECT %s FROM %s WHERE %s = '%d' limit %d offset %d", fields, table, matchfield, id.to_s, limit, offset)
      count = get_count(table, sprintf("WHERE %s = '%d'", matchfield, id.to_s))
    end
    return do_query(query, key, count)
  end

  def get_new_noids(key, table, params)
    limit = params[:limit] || '10'
    offset = params[:offset] || '0'
    check_class(limit, 'limit')
    check_class(offset, 'offset')
    limit = check_hang_equal(limit, '10')
    offset = check_hang_equal(offset, '0')
    check_max(limit, 5000)

    fields = params[:fields] || '*'
    params.delete("limit")
    params.delete("fields")
    fields = check_fields(table, fields)
    args = get_args(check_params(table, params))
    query = sprintf("SELECT %s FROM %s %s limit %d offset %d", fields, table, args, limit, offset)
    count = get_count(table, args)
    return do_query(query, key, count)
  end

  def do_query(query, key, count)
    res = $slbclient.query(query, :as => :json)
    out = res.collect{ |row| row }
    err = get_error(out)
    store = {"count" => count, "error" => err, "data" => out}
    redis_set(key, JSON.generate(store))
    return store
  end

  def check_max(x, max)
    if x.to_i > max
      halt 400, {'Content-Type' => 'application/json'}, JSON.generate({ 'error' => 'invalid request', 'message' => sprintf('maximum limit is %d', max)})
    end
  end

  def check_class(x, param)
    mm = x.match(/[a-zA-Z]+/)
    if !mm.nil?
      halt 400, {'Content-Type' => 'application/json'}, JSON.generate({ 'error' => 'invalid request', 'message' => sprintf('%s must be an integer', param)})
    end
  end

  def check_hang_equal(x, default)
    if x == ""
      return default
    else
      return x
    end
  end

end
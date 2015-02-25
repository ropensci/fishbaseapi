require 'rubygems'
require 'sinatra'
require 'json'
require 'mysql2'
require 'redis'
require 'geolocater'


class FBApp < Sinatra::Application

  $use_caching = false
  $use_logging = true
  log_file_path = "fishbaseapi.log"
  host = ENV['MYSQL_PORT_3306_TCP_ADDR']

  # Set up MySQL DB
  if host.to_s == ''
    $client = Mysql2::Client.new(:host => "localhost",
                                :username => "root",
                                :database => "fbapp",
                                :reconnect => true)
  else
    # Connect to a MySQL server via a linked docker container
    $client = Mysql2::Client.new(
                               :host => "mysql",
                               :port => ENV['MYSQL_PORT_3306_TCP_PORT'],
                               :password => ENV['MYSQL_ENV_MYSQL_ROOT_PASSWORD'],
                               :username => "root",
                               :database => "fbapp",
                               :reconnect => true)
  end

  # Set up Redis for caching
  $redis = Redis.new(:host => ENV['REDIS_PORT_6379_TCP_ADDR'],
                    :port => ENV['REDIS_PORT_6379_TCP_PORT'],
                    :timeout => 20,
                    :connect_timeout => 20)

  # before do
  #   puts '[Params]'
  #   p params
  # end

  # before do
  #   puts '[env]'
  #   p env
  # end

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

  class LogstashLogger < Rack::CommonLogger
    private

    def log(env, status, header, began_at)
      now    = Time.now
      length = extract_content_length(header)
      logger = @logger || env['rack.errors']
      json = {
        '@timestamp' => now.utc.iso8601,
        '@ip' => ip_anonymize(env['REMOTE_ADDR']),
        '@fields'      => {
          'remoteadd'  => env['REMOTE_ADDR'],
          'ipadd'      => $ip,
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

    file = File.new(File.join(File.expand_path('~'), log_file_path), 'a+')
    file.sync = true

    use LogstashLogger, file
  end

  # configure do
  #   enable :logging
  #   file = File.new("/Users/sacmac/fishbaseapi.log", 'a+')
  #   file.sync = true
  #   use Rack::CommonLogger, file
  # end

  not_found do
    halt 404, {'Content-Type' => 'application/json'}, JSON.generate({ 'error' => 'route not found' })
  end

  before do
    headers "Content-Type" => "application/json; charset=utf8"
    cache_control :public, :must_revalidate, :max_age => 60
  end

  get '/' do
    redirect '/heartbeat'
  end

  get "/heartbeat/?" do
    $ip = request.ip
    return JSON.pretty_generate({
      "paths" => [
        "/heartbeat",
        "/mysqlping",
        "/species/:id?<params>",
        "/genera/:id?<params>",
        "/faoareas/:id?<params>",
        "/faoarref/:id?<params>",
        "/fooditems?<params>",
        "/oxygen?<params>",
        "/taxa?<params>",
        "/synonyms?<params>",
        "/comnames?<params>",
        "/popgrowth?<params>",
        "/country?<params>",
        "/countref?<params>"
      ]
    })
  end

  get '/mysqlping/?' do
    return JSON.pretty_generate({
      "mysql_server_up" => $client.ping,
      "mysql_host" => $client.query_options[:host]
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

  get '/ecology/?' do
    route_noid('ecology')
  end

  get '/faoareas/?:id?/?' do
    route('faoareas', 'AreaCode')
  end

  get '/faoarref/?:id?/?' do
    route('faoarref', 'AreaCode')
  end

  get '/fooditems/?' do
    route_noid('fooditems')
  end

  get '/genera/?:id?/?' do
    route('genera', 'GenCode')
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

  get '/poplw/?' do
    route_noid('poplw')
  end

  get '/species/?:id?/?' do
    route('species', 'SpecCode')
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
        SELECT s.SpecCode,s.Genus,s.Species,s.SpeciesRefNo,s.Author,s.SubFamily,s.FamCode,s.GenCode,s.SubGenCode,s.Remark,f.Family,f.Order,f.Class
          FROM species s
          INNER JOIN families f on s.FamCode = f.FamCode
          INNER JOIN genera g on s.GenCode = g.GenCode
          %s limit %d", args, limit)
      count = get_count('species', get_args(params, prefix=false))

      res = $client.query(query, :as => :json)
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

  # helpers
  def route(table, var)
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
        return $redis.set(key, value)
      rescue
        return nil
      end
  	end
  end

  def redis_get(key)
    begin
      return $redis.get(key)
    rescue
      return nil
    end
  end

  def redis_exists(key)
  	if !$use_caching
  		return false
  	else
      begin
        return $redis.exists(key)
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
    	halt not_found
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
    res = $client.query(query, :as => :json)
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
      res = $client.query(query, :as => :json)
      flexist = ["^", res.fields.join('$|^'), "$"].join('').downcase
      params = params.keep_if { |key, value| key.downcase.to_s.match(flexist) }
      return params
    end
  end

  def get_count(table, string)
    query = sprintf("SELECT count(*) as ct FROM %s %s", table, string)
    res = $client.query(query, :as => :json)
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
    limit = params[:limit] || 10
    fields = params[:fields] || '*'
    params.delete("limit")
    params.delete("fields")

    fields = check_fields(table, fields)
    args = get_args(check_params(table, params))

    if id.nil?
      query = sprintf("SELECT %s FROM %s %s limit %d", fields, table, args, limit)
      count = get_count(table, args)
    else
      query = sprintf("SELECT %s FROM %s WHERE %s = '%d' limit %d", fields, table, matchfield, id.to_s, limit)
      count = get_count(table, sprintf("WHERE %s = '%d'", matchfield, id.to_s))
    end
    return do_query(query, key, count)
  end

  def get_new_noids(key, table, params)
    limit = params[:limit] || 10
    fields = params[:fields] || '*'
    params.delete("limit")
    params.delete("fields")
    fields = check_fields(table, fields)
    args = get_args(check_params(table, params))
    query = sprintf("SELECT %s FROM %s %s limit %d", fields, table, args, limit)
    count = get_count(table, args)
    return do_query(query, key, count)
  end

  def do_query(query, key, count)
    res = $client.query(query, :as => :json)
    out = res.collect{ |row| row }
    err = get_error(out)
    store = {"count" => count, "error" => err, "data" => out}
    redis_set(key, JSON.generate(store))
    return store
  end

end

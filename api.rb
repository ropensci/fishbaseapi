require 'rubygems'
require 'sinatra'
require 'json'
require 'mysql2'
require 'redis'
require 'geolocater'


class FBApp < Sinatra::Application

  $use_caching = true
  $use_logging = true
  log_file_path = "fishbaseapi.log"
  host = ENV['MYSQL_PORT_3306_TCP_ADDR']

  # Set up MySQL DB
  if host.to_s == ''
    client = Mysql2::Client.new(:host => "localhost",
                                :username => "root",
                                :database => "fbapp",
                                :reconnect => true)
  else
    # Connect to a MySQL server via a linked docker container
    client = Mysql2::Client.new(:host => ENV['MYSQL_PORT_3306_TCP_ADDR'],
                               :port => ENV['MYSQL_PORT_3306_TCP_PORT'],
                               :password => ENV['MYSQL_ENV_MYSQL_ROOT_PASSWORD'],
                               :username => "root",
                               :database => "fbapp",
                               :reconnect => true)
  end

  # Set up Redis for caching
  $redis = Redis.new(:host => ENV['REDIS_PORT_6379_TCP_ADDR'],
                    :port => ENV['REDIS_PORT_6379_TCP_PORT'])

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
        "/faoarrefs/:id?<params>",
        "/fooditems?<params>",
        "/oxygens?<params>",
        "/taxa?<params>",
        "/synonyms?<params>",
        "/comnames?<params>",
        "/populations?<params>"
      ]
    })
  end

  get '/mysqlping/?' do
    return JSON.pretty_generate({
      "mysql_server_up" => client.ping
    })
  end

  get '/species/?:id?/?' do
    key = rediskey('species', params)
    if redis_exists(key)
      obj = get_cached(key)
    else
      obj = get_new_ids(client, key, 'species', 'SpecCode', params)
    end
    return give_data(obj)
  end

  get '/genera/?:id?/?' do
    key = rediskey('genera', params)
    if redis_exists(key)
      obj = get_cached(key)
    else
      obj = get_new_ids(client, key, 'genera', 'GenCode', params)
    end
    return give_data(obj)
  end

  get '/faoareas/?:id?/?' do
    key = rediskey('faoareas', params)
    if redis_exists(key)
      obj = get_cached(key)
    else
      obj = get_new_ids(client, key, 'faoareas', 'AreaCode', params)
    end
    return give_data(obj)
  end

  get '/faoarrefs/?:id?/?' do
    key = rediskey('faoarref', params)
    if redis_exists(key)
      obj = get_cached(key)
    else
      obj = get_new_ids(client, key, 'faoarref', 'AreaCode', params)
    end
    return give_data(obj)
  end

  get '/fooditems/?' do
    key = rediskey('fooditems', params)
    if redis_exists(key)
      obj = get_cached(key)
    else
      obj = get_new_noids(client, key, 'fooditems', params)
    end
    return give_data(obj)
  end

  get '/oxygens/?' do
    key = rediskey('oxygen', params)
    if redis_exists(key)
      obj = get_cached(key)
    else
      obj = get_new_noids(client, key, 'oxygen', params)
    end
    return give_data(obj)
  end

  get '/taxa/?' do
    key = rediskey('taxa', params)
    if redis_exists(key)
      result = JSON.parse(redis_get(key))
      out = result['data']
      err = result['error']
      count = result['count']
    else
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
      count = get_count(client, 'species', get_args(params, prefix=false))

      res = client.query(query, :as => :json)
      out = res.collect{ |row| row }
      err = get_error(out)
      store = {"count" => count, "error" => err, "data" => out}
      redis_set(key, JSON.generate(store))
    end

    data = { "count" => count, "returned" => out.length, "error" => err, "data" => out }
    return JSON.pretty_generate(data)
  end

  get '/synonyms/?' do
    key = rediskey('synonyms', params)
    if redis_exists(key)
      obj = get_cached(key)
    else
      obj = get_new_noids(client, key, 'synonyms', params)
    end
    return give_data(obj)
  end

  get '/comnames/?' do
    key = rediskey('comnames', params)
    if redis_exists(key)
      obj = get_cached(key)
    else
      obj = get_new_noids(client, key, 'comnames', params)
    end
    return give_data(obj)
  end

  get '/populations/?' do
    key = rediskey('PopGrowth', params)
    if redis_exists(key)
      obj = get_cached(key)
    else
      obj = get_new_noids(client, key, 'PopGrowth', params)
    end
    return give_data(obj)
  end

  get '/countries/?' do
    key = rediskey('country', params)
    if redis_exists(key)
      obj = get_cached(key)
    else
      obj = get_new_noids(client, key, 'country', params)
    end
    return give_data(obj)
  end

  get '/countref/?' do
    key = rediskey('countref', params)
    if redis_exists(key)
      obj = get_cached(key)
    else
      obj = get_new_noids(client, key, 'countref', params)
    end
    return give_data(obj)
  end

  # helpers
  def redis_set(key, value)
  	if $use_caching
    	return $redis.set(key, value)
  	end
  end

  def redis_get(key)
    return $redis.get(key)
  end

  def redis_exists(key)
  	if !$use_caching
  		return false
  	else
  		return $redis.exists(key)
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

  def check_fields(client, table, fields)
    query = sprintf("SELECT * FROM %s limit 1", table)
    res = client.query(query, :as => :json)
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

  def check_params(client, table, params)
    if params.length == 0
      return params
    else
      query = sprintf("SELECT * FROM %s limit 1", table)
      res = client.query(query, :as => :json)
      flexist = ["^", res.fields.join('$|^'), "$"].join('').downcase
      params = params.keep_if { |key, value| key.downcase.to_s.match(flexist) }
      return params
    end
  end

  def get_count(client, table, string)
    query = sprintf("SELECT count(*) as ct FROM %s %s", table, string)
    res = client.query(query, :as => :json)
    res.collect{ |row| row }[0]["ct"]
  end

  def give_data(obj)
    data = { "count" => obj['count'], "returned" => obj['data'].length, "error" => obj['error'], "data" => obj['data'] }
    return JSON.pretty_generate(data)
  end

  def get_cached(key)
    return JSON.parse(redis_get(key))
  end

  def get_new_ids(client, key, table, matchfield, params)
    id = params[:id]
    limit = params[:limit] || 10
    fields = params[:fields] || '*'
    params.delete("limit")
    params.delete("fields")

    fields = check_fields(client, table, fields)
    args = get_args(check_params(client, table, params))

    if id.nil?
      query = sprintf("SELECT %s FROM %s %s limit %d", fields, table, args, limit)
      count = get_count(client, table, args)
    else
      query = sprintf("SELECT %s FROM %s WHERE %s = '%d' limit %d", fields, table, matchfield, id.to_s, limit)
      count = get_count(client, table, sprintf("WHERE %s = '%d'", matchfield, id.to_s))
    end
    return do_query(client, query, key, count)
  end

  def get_new_noids(client, key, table, params)
    limit = params[:limit] || 10
    fields = params[:fields] || '*'
    params.delete("limit")
    params.delete("fields")
    fields = check_fields(client, table, fields)
    args = get_args(check_params(client, table, params))
    query = sprintf("SELECT %s FROM %s %s limit %d", fields, table, args, limit)
    count = get_count(client, table, args)
    return do_query(client, query, key, count)
  end

  def do_query(client, query, key, count)
    res = client.query(query, :as => :json)
    out = res.collect{ |row| row }
    err = get_error(out)
    store = {"count" => count, "error" => err, "data" => out}
    redis_set(key, JSON.generate(store))
    return store
  end

end

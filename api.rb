require 'rubygems'
require 'sinatra'
require 'json'
require 'mysql2'
require 'redis'

log_file_path = "fishbaseapi2.log"
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
redis = Redis.new(:host => ENV['REDIS_PORT_6379_TCP_ADDR'],
                  :port => ENV['REDIS_PORT_6379_TCP_PORT'])

before do
  # puts '[Params]'
  # p params
  puts '[env]'
  p env
end

class LogstashLogger < Rack::CommonLogger
  private

  def log(env, status, header, began_at)
    now    = Time.now
    length = extract_content_length(header)
    logger = @logger || env['rack.errors']

    json = {
      '@timestamp' => now.utc.iso8601,
      '@ip' => env['REMOTE_ADDR'],
      '@fields'      => {
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
	enable :logging

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
	halt 404, {'Content-Type' => 'application/json'}, {'error' => 'Page not found'}
end

before do
  headers "Content-Type" => "application/json; charset=utf8"
  cache_control :public, :must_revalidate, :max_age => 60
end

get '/' do
	redirect '/heartbeat'
end

get "/heartbeat/?" do
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
	if redis_exists(redis, key)
		obj = get_cached(redis, key)
	else
		obj = get_new_ids(client, redis, key, 'species', 'SpecCode', params)
	end
	return give_data(obj)
end

get '/genera/?:id?/?' do
	key = rediskey('genera', params)
	if redis_exists(redis, key)
		obj = get_cached(redis, key)
	else
		obj = get_new_ids(client, redis, key, 'genera', 'GenCode', params)
	end
	return give_data(obj)
end

get '/faoareas/?:id?/?' do
	key = rediskey('faoareas', params)
	if redis_exists(redis, key)
		obj = get_cached(redis, key)
	else
		obj = get_new_ids(client, redis, key, 'faoareas', 'AreaCode', params)
	end
	return give_data(obj)
end

get '/faoarrefs/?:id?/?' do
	key = rediskey('faoarref', params)
	if redis_exists(redis, key)
		obj = get_cached(redis, key)
	else
		obj = get_new_ids(client, redis, key, 'faoarref', 'AreaCode', params)
	end
	return give_data(obj)
end

get '/fooditems/?' do
	key = rediskey('fooditems', params)
	if redis_exists(redis, key)
		obj = get_cached(redis, key)
	else
		obj = get_new_noids(client, redis, key, 'fooditems', params)
	end
	return give_data(obj)
end

get '/oxygens/?' do
	key = rediskey('oxygen', params)
	if redis_exists(redis, key)
		obj = get_cached(redis, key)
	else
		obj = get_new_noids(client, redis, key, 'oxygen', params)
	end
	return give_data(obj)
end

get '/taxa/?' do
	key = rediskey('taxa', params)
	if redis_exists(redis, key)
		result = JSON.parse(redis_get(redis, key))
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
		redis_set(redis, key, JSON.generate(store))
	end

	data = { "count" => count, "returned" => out.length, "error" => err, "data" => out }
	return JSON.pretty_generate(data)
end

get '/synonyms/?' do
	key = rediskey('synonyms', params)
	if redis_exists(redis, key)
		obj = get_cached(redis, key)
	else
		obj = get_new_noids(client, redis, key, 'synonyms', params)
	end
	return give_data(obj)
end

get '/comnames/?' do
	key = rediskey('comnames', params)
	if redis_exists(redis, key)
		obj = get_cached(redis, key)
	else
		obj = get_new_noids(client, redis, key, 'comnames', params)
	end
	return give_data(obj)
end

get '/populations/?' do
	key = rediskey('PopGrowth', params)
	if redis_exists(redis, key)
		obj = get_cached(redis, key)
	else
		obj = get_new_noids(client, redis, key, 'PopGrowth', params)
	end
	return give_data(obj)
end

# helpers
def redis_set(rd, key, value)
	return rd.set(key, value)
end

def redis_get(rd, key)
	return rd.get(key)
end

def redis_exists(rd, key)
	return rd.exists(key)
end

def rediskey(table, x)
	[table, '_', x.collect{ |key, value| [key,value].join(':') }.join].join
end

def get_error(x)
	if x.length == 0
		return "not found"
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

def get_count(client, table, string)
	query = sprintf("SELECT count(*) as ct FROM %s %s", table, string)
	res = client.query(query, :as => :json)
	res.collect{ |row| row }[0]["ct"]
end

def give_data(obj)
	data = { "count" => obj['count'], "returned" => obj['data'].length, "error" => obj['error'], "data" => obj['data'] }
	return JSON.pretty_generate(data)
end

def get_cached(redis, key)
	return JSON.parse(redis_get(redis, key))
end

def get_new_ids(client, redis, key, table, matchfield, params)
	id = params[:id]
	limit = params[:limit] || 10
	fields = params[:fields] || '*'
	params.delete("limit")
	params.delete("fields")

	fields = check_fields(client, table, fields)
	args = get_args(params)

	if id.nil?
		query = sprintf("SELECT %s FROM %s %s limit %d", fields, table, args, limit)
		count = get_count(client, table, args)
	else
		query = sprintf("SELECT %s FROM %s WHERE %s = '%d' limit %d", fields, table, matchfield, id.to_s, limit)
		count = get_count(client, table, sprintf("WHERE %s = '%d'", matchfield, id.to_s))
	end
	return do_query(client, query, redis, key, count)
end

def get_new_noids(client, redis, key, table, params)
	limit = params[:limit] || 10
	fields = params[:fields] || '*'
	params.delete("limit")
	params.delete("fields")
	fields = check_fields(client, table, fields)
	args = get_args(params)
	query = sprintf("SELECT %s FROM %s %s limit %d", fields, table, args, limit)
	count = get_count(client, table, args)
	return do_query(client, query, redis, key, count)
end

def do_query(client, query, redis, key, count)
	res = client.query(query, :as => :json)
	out = res.collect{ |row| row }
	err = get_error(out)
	store = {"count" => count, "error" => err, "data" => out}
	redis_set(redis, key, JSON.generate(store))
	return store
end

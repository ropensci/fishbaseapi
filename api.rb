require 'rubygems'
require 'sinatra'
require 'json'
require 'mysql2'



host = ENV['MYSQL_PORT_3306_TCP_ADDR']

if host.to_s == ''
  client = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "fbapp")
else
  # Connect to a MySQL server via a linked docker container
  client = Mysql2::Client.new(:host => ENV['MYSQL_PORT_3306_TCP_ADDR'],
                             :port => ENV['MYSQL_PORT_3306_TCP_PORT'],
                             :password => ENV['MYSQL_ENV_MYSQL_ROOT_PASSWORD'],
                             :username => "root",
                             :database => "fbapp")
end

before do
  puts '[Params]'
  p params
end

not_found do
	halt 402, {'Content-Type' => 'application/json'}, {'error' => 'Page not found'}
  # 'This is nowhere to be found.'
end

error 404 do
  'Not found'
end

before do
  headers "Content-Type" => "application/json; charset=utf8"
end

get '/' do
	redirect '/heartbeat'
end

get "/heartbeat" do
	return JSON.pretty_generate({
		"paths" => [
			"/heartbeat",
			"/species/:id?<params>",
			"/genera/:id?<params>",
			"/faoareas/:id?<params>",
			"/fooditems?<params>"
		]
	})
end

get '/species/?:id?/?' do
	id = params[:id]
 	limit = params[:limit] || 10
 	fields = params[:fields] || '*'
 	params.delete("limit")
 	params.delete("fields")

 	fields = check_fields(client, 'species', fields)
 	args = get_args(params)

	if id.nil?
		query = sprintf("SELECT %s FROM species %s limit %d", fields, args, limit)
	else
		query = sprintf("SELECT %s FROM species WHERE SpecCode = '%d' limit %d", fields, id.to_s, limit)
	end
	res = client.query(query, :as => :json)
	out = res.collect{ |row| row }
	err = get_error(out)
	data = { "count" => out.length, "returned" => out.length, "error" => err, "data" => out }
	return JSON.pretty_generate(data)
end

get '/genera/?:id?/?' do
	id = params[:id]
 	limit = params[:limit] || 10
 	fields = params[:fields] || '*'
 	params.delete("limit")
 	params.delete("fields")

 	fields = check_fields(client, 'genera', fields)
 	args = get_args(params)

	if id.nil?
		query = sprintf("SELECT %s FROM genera %s limit %d", fields, args, limit)
	else
		query = sprintf("SELECT %s FROM genera WHERE GenCode = '%d' limit %d", fields, id.to_s, limit)
	end
	res = client.query(query, :as => :json)
	out = res.collect{ |row| row }
	err = get_error(out)
	data = { "count" => out.length, "returned" => out.length, "error" => err, "data" => out }
	return JSON.pretty_generate(data)
end

get '/faoareas/?:id?/?' do
	id = params[:id]
 	limit = params[:limit] || 10
 	fields = params[:fields] || '*'
 	params.delete("limit")
 	params.delete("fields")

 	fields = check_fields(client, 'faoareas', fields)
 	args = get_args(params)

	if id.nil?
		query = sprintf("SELECT %s FROM faoareas %s limit %d", fields, args, limit)
		count = get_count(client, 'faoareas', args)
	else
		query = sprintf("SELECT %s FROM faoareas WHERE AreaCode = '%d' limit %d", fields, id.to_s, limit)
		count = get_count(client, 'faoareas', sprintf("WHERE AreaCode = '%d'", id.to_s))
	end
	res = client.query(query, :as => :json)
	out = res.collect{ |row| row }
	err = get_error(out)
	data = { "count" => count, "returned" => out.length, "error" => err, "data" => out }
	return JSON.pretty_generate(data)
end

get '/fooditems/?' do
	limit = params[:limit] || 10
	fields = params[:fields] || '*'

	params.delete("limit")
 	params.delete("fields")

 	fields = check_fields(client, 'fooditems', fields)
 	args = get_args(params)

 	query = sprintf("SELECT %s FROM fooditems %s limit %d", fields, args, limit)
	count = get_count(client, 'faoareas', args)

	res = client.query(query, :as => :json)
	out = res.collect{ |row| row }
	err = get_error(out)
	data = { "count" => out.length, "returned" => out.length, "error" => err, "data" => out }
	return JSON.pretty_generate(data)
end

# helpers
def get_error(x)
	if x.length == 0
		return "not found"
	else
		return nil
	end
end

def get_args(x)
	res = x.collect{ |row| "%s = '%s'" % row }
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

# def request(client, query)
# 	res = client.query(query, :as => :json)
# 	out = res.collect{ |row| row }
# 	return out
# end

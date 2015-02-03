require 'rubygems'
require 'sinatra'
require 'json'
require 'mysql2'

client = Mysql2::Client.new(:host => "localhost", :username => "root", :database => "fbapp")

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
		"status" => "ok",
		"paths" => [
			"/heartbeat",
			"/species/:id?<params>",
			"/genera/:id?<params>"
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
		query = sprintf("SELECT %s FROM species WHERE SpecCode = '%d'", fields, id.to_s)
	end
	res = client.query(query, :as => :json)
	out = res.collect{ |row| row }
	err = get_error(out)
	data = { "status" => "ok", "count" => out.length, "error" => err, "data" => out }
	return JSON.pretty_generate(data)
end

get '/genera/?:id?/?' do
	id = params[:id]
 	genus = params[:genus]
 	gender = params[:gender]
 	limit = params.fetch :limit, 10
	if id.nil?
		query = sprintf("SELECT * FROM genera WHERE GenName = '%s' limit %d", genus, limit)
	else
		query = sprintf("SELECT * FROM genera WHERE GenCode = '%d'", id.to_s)
	end
	res = client.query(query, :as => :json)
	out = res.collect{ |row| row }
	err = get_error(out)
	data = { "status" => "ok", "count" => out.length, "error" => err, "data" => out }
	return JSON.pretty_generate(data)
end

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

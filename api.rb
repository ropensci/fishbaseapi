require 'rubygems'
require 'sinatra'
require 'httparty'
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
			"/species/:id?params..."
		]
	})
end

get '/species/:id?/?' do
	# id = params[:splat].first
	id = params[:id]
 	genus = params[:genus]
 	species = params[:species]
	if id.nil?
		query = sprintf("SELECT * FROM species WHERE genus = '%s'", genus)
	else
		query = sprintf("SELECT * FROM species WHERE SpecCode = '%d'", id.to_s)
	end
	res = client.query(query, :as => :json)
	out = res.collect{ |row| row }
	err = get_error(out)
	data = { "status" => "ok", "count" => out.length, "error" => err, "data" => out }
	return JSON.pretty_generate(data)
end

# get '/stuff/search/?' do
# 	genus = params[:genus]
# 	species = params[:species]

# 	query = sprintf("SELECT * FROM species WHERE genus='%s'", genus)

# 	res = client.query(query, :as => :json)
# 	out = res.collect{ |row| row }
# 	err = get_error(out)
# 	data = { "status" => "ok", "count" => out.length, "error" => err, "data" => out }
# 	return JSON.pretty_generate(data)
# end

# get '/search' do
# 	url2 = url + '/_search'
# 	options = {
# 		query: {
# 			q: params[:q],
# 			size: params[:size]
# 		}
# 	}
# 	res = HTTParty.get(url2, options)
# 	body = JSON.parse(res.body)
# 	body['hits']['hits'] = body['hits']['hits'].collect {
# 		|p| {"score" => p['_score'], "source" => p['_source'] }
# 	}
# 	out = { "status" => "ok", "data" => body['hits'] }
# 	return JSON.pretty_generate(out)
# end

def get_error(x)
	if x.length == 0
		"not found"
	else
		nil
	end
end

require 'rubygems'
require 'sinatra'

class App < Sinatra::Application
  get %r{/.*} do
    puts "A request has arrived #{params.inspect}"
    response = "Hello"
    puts "Response is #{response}"
    return response
  end
end


require "rubygems"
require "sinatra"
require 'json'
require 'mysql2'
require 'redis'
require 'geolocater'


map '/' do
	require File.join( File.dirname(__FILE__), 'api.rb')
	run FBApp
end

map '/sealifebase' do
	require File.join( File.dirname(__FILE__), 'sealifebase.rb')
	run SLBApp
end

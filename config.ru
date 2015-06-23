require "rubygems"
require "sinatra"
require 'json'
require 'mysql2'
require 'redis'
require 'geolocater'

require File.join( File.dirname(__FILE__), 'api.rb')
require File.join( File.dirname(__FILE__), 'sealifebase.rb')


map '/' do
	run FBApp
end

#map '/sealifebase' do
#	run SLBApp
#end

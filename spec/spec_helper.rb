require_relative '../api'
Bundler.require(:test)

ENV['RACK_ENV'] = 'test'

module TestHelperMixin
  include Rack::Test::Methods
  def app
    API
  end
end

RSpec.configure do |config|
  config.include TestHelperMixin
end

$routes = API.routes['GET'].map do |route|
  route[0].to_s
      .sub('(?-mix:\A\/', '/')
      .sub('\/?', '/')
      .sub('\z)', '')
      .sub('([^\/?#]+)?\/?', '')
end.drop(1)

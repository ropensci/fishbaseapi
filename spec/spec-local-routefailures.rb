require File.expand_path 'test_helper.rb'

class FBAppRoutes < Minitest::Test

  include Rack::Test::Methods

  def app
    FBApp
  end

  def test_route_not_found
    get '/foobar'
    assert !last_response.ok?
    assert 404, last_response.status
  end

  def test_method_not_allowed
    post '/species'
    assert !last_response.ok?
    assert 405, last_response.status

    delete '/species'
    assert !last_response.ok?
    assert 405, last_response.status

    put '/species'
    assert !last_response.ok?
    assert 405, last_response.status

    options '/species'
    assert !last_response.ok?
    assert 405, last_response.status
  end

end

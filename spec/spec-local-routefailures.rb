require File.expand_path 'test_helper.rb'

require 'json'

class FBAppRoutes < Minitest::Test

  include Rack::Test::Methods

  def app
    FBApp
  end

  def test_route_not_found
    get '/foobar'
    assert !last_response.ok?
    assert 404, last_response.status

    get '/docs/foobar'
    assert !last_response.ok?
    assert 404, last_response.status
  end

  def test_wrong_input
    get '/species/foobar'
    assert !last_response.ok?
    assert 400, last_response.status
    assert "id must be an integer", JSON.parse(last_response.body)['error']

    get '/faoareas/foobar'
    assert !last_response.ok?
    assert 400, last_response.status
    assert "id must be an integer", JSON.parse(last_response.body)['error']

    get '/faoarref/foobar'
    assert !last_response.ok?
    assert 400, last_response.status
    assert "id must be an integer", JSON.parse(last_response.body)['error']

    get '/genera/foobar'
    assert !last_response.ok?
    assert 400, last_response.status
    assert "id must be an integer", JSON.parse(last_response.body)['error']
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

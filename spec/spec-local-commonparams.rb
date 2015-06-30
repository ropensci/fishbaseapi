require File.expand_path 'test_helper.rb'

class FBAppCommonParams < Minitest::Test

  include Rack::Test::Methods

  def app
    FBApp
  end

  $fields = "{\n  \"count\": 32792,\n  \"returned\": 1,\n  \"error\": null,\n  \"data\": [\n    {\n      \"SpecCode\": 16239,\n      \"Genus\": \"Aaptosyax\"\n    }\n  ]\n}"

  def test_fields
    get '/species?limit=1&fields=SpecCode,Genus'
    assert last_response.ok?
    assert $fields, last_response.body
  end

  def test_limit
    get '/species?limit=1'
    assert last_response.ok?
    assert 1, JSON.parse(last_response.body)['returned']

    get '/species?limit=2'
    assert last_response.ok?
    assert 2, JSON.parse(last_response.body)['returned']
  end

  def test_limit_bad_character
    get '/species?limit=stuff'
    assert !last_response.ok?
    assert 400, last_response.status
    assert "limit must be an integer", JSON.parse(last_response.body)['message']
  end

  def test_limit_bad_toobig
    get '/species?limit=6000'
    assert !last_response.ok?
    assert 400, last_response.status
    assert "maximum limit is 5000", JSON.parse(last_response.body)['message']
  end

  def test_offset_bad_character
    get '/species?offset=adfadfads'
    assert !last_response.ok?
    assert 400, last_response.status
    assert "offset must be an integer", JSON.parse(last_response.body)['message']
  end

end

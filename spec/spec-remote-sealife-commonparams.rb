require File.expand_path 'test_fxns.rb'

require 'minitest/autorun'
require 'httparty'
require 'json'

class RemoteCommonParamsSealife < Minitest::Test

  $fields = "{\n  \"count\": 32792,\n  \"returned\": 1,\n  \"error\": null,\n  \"data\": [\n    {\n      \"SpecCode\": 16239,\n      \"Genus\": \"Aaptosyax\"\n    }\n  ]\n}"

  def test_fields
    res = fetch('sealifebase/species?limit=1&fields=SpecCode,Genus')
    assert res.ok?
    assert $fields, res.body
  end

  def test_limit
    res = fetch('sealifebase/species?limit=1')
    assert res.ok?
    assert 1, JSON.parse(res.body)['returned']

    res = fetch('sealifebase/species?limit=2')
    assert res.ok?
    assert 2, JSON.parse(res.body)['returned']
  end

  def test_limit_bad_character
    res = fetch('sealifebase/species?limit=stuff')
    assert !res.ok?
    assert 400, res.code
    assert "limit must be an integer", JSON.parse(res.body)['message']
  end

  def test_limit_bad_toobig
    res = fetch('sealifebase/species?limit=6000')
    assert !res.ok?
    assert 400, res.code
    assert "maximum limit is 5000", JSON.parse(res.body)['message']
  end

  def test_offset_bad_character
    res = fetch('sealifebase/species?offset=adfadfads')
    assert !res.ok?
    assert 400, res.code
    assert "offset must be an integer", JSON.parse(res.body)['message']
  end

end

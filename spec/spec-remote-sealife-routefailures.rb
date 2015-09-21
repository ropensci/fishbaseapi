require File.expand_path 'test_fxns.rb'

require 'minitest/autorun'
require 'httparty'
require 'json'

class RemoteRouteFailuresSealife < MiniTest::Test

  def test_route_not_found
    res = fetch('sealifebase/foobar')
    assert !res.ok?
    assert 404, res.code

    res = fetch('sealifebase/docs/foobar')
    assert !res.ok?
    assert 404, res.code
  end

  def test_wrong_input
    res = fetch('sealifebase/species/foobar')
    assert !res.ok?
    assert 400, res.code
    assert "id must be an integer", JSON.parse(res.body)['error']

    res = fetch('sealifebase/faoareas/foobar')
    assert !res.ok?
    assert 400, res.code
    assert "id must be an integer", JSON.parse(res.body)['error']

    res = fetch('sealifebase/faoarref/foobar')
    assert !res.ok?
    assert 400, res.code
    assert "id must be an integer", JSON.parse(res.body)['error']

    res = fetch('sealifebase/genera/foobar')
    assert !res.ok?
    assert 400, res.code
    assert "id must be an integer", JSON.parse(res.body)['error']
  end

  def test_method_not_allowed
    base_sp = $base + "sealifebase/" + "species"

    res = HTTParty.post(base_sp)
    assert !res.ok?
    assert 405, res.code

    res = HTTParty.delete(base_sp)
    assert !res.ok?
    assert 405, res.code

    res = HTTParty.put(base_sp)
    assert !res.ok?
    assert 405, res.code

    res = HTTParty.options(base_sp)
    assert !res.ok?
    assert 405, res.code
  end

end

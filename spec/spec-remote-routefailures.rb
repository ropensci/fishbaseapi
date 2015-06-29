require File.expand_path 'test_fxns.rb'

require 'minitest/autorun'
require 'httparty'
require 'json'

class RemoteRouteFailures < MiniTest::Test

  def test_route_not_found
    res = fetch('foobar')
    assert !res.ok?
    assert 404, res.code
  end

  def test_method_not_allowed
    base_sp = $base + "species"

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

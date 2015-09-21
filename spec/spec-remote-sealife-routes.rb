require File.expand_path 'test_fxns.rb'

require 'minitest/autorun'
require 'httparty'
require 'json'

class RemoteRoutesSealife < MiniTest::Test

  def test_route_sealifebase_root
    res = fetch("sealifebase")
    assert res.ok?
    assert 302, res.code
  end

  def test_route_sealifebase_docs
    res = fetch('sealifebase/docs')
    assert res.ok?
  end

  def test_route_sealifebase_docs_species
    res = fetch('sealifebase/docs/species')
    assert res.ok?
  end

  def test_route_sealifebase_heartbeat
    res = fetch('sealifebase/heartbeat')
    assert res.ok?
  end

  def test_route_sealifebase_mysqlping
    res = fetch('sealifebase/mysqlping')
    assert res.ok?
    assert_equal true, JSON.parse(res.body)['mysql_server_up']
  end

  def test_route_sealifebase_comnames
    res = fetch('sealifebase/comnames')
    assert res.ok?
  end

  def test_route_sealifebase_countref
    res = fetch('sealifebase/countref')
    assert res.ok?

    res = fetch('sealifebase/countref?SpecCode=24&fields=GrowthCountFresh,ABB')
    assert res.ok?
  end

  def test_route_sealifebase_country
    res = fetch('sealifebase/country')
    assert res.ok?
  end

  def test_route_sealifebase_diet
    res = fetch('sealifebase/diet')
    assert res.ok?
  end

  def test_route_sealifebase_ecology
    res = fetch('sealifebase/ecology')
    assert res.ok?
  end

  def test_route_sealifebase_ecosystem
    res = fetch('sealifebase/ecosystem')
    assert res.ok?
  end

  def test_route_sealifebase_faoareas
    res = fetch('sealifebase/faoareas')
    assert res.ok?
  end

  def test_route_sealifebase_faoarref
    res = fetch('sealifebase/faoarref')
    assert res.ok?
    # assert_equal $faoarref, res.body
  end

  def test_route_sealifebase_fecundity
    res = fetch('sealifebase/fecundity')
    assert res.ok?
    # assert_equal $fecundity, res.body
  end

  def test_route_sealifebase_fooditems
    res = fetch('sealifebase/fooditems')
    assert res.ok?
    # assert_equal $fooditems, res.body
  end

  def test_route_sealifebase_genera
    res = fetch('sealifebase/genera')
    assert res.ok?
    # assert_equal $genera, res.body
  end

  def test_route_sealifebase_intrcase
    res = fetch('sealifebase/intrcase')
    assert res.ok?
    # assert_equal $intrcase, res.body
  end

  def test_route_sealifebase_listfields
    res = fetch('sealifebase/listfields')
    assert res.ok?
    # assert_equal $intrcase, res.body
  end

  def test_route_sealifebase_maturity
    res = fetch('sealifebase/maturity')
    assert res.ok?
    # assert_equal $maturity, res.body
  end

  def test_route_sealifebase_morphdat
    res = fetch('sealifebase/morphdat')
    assert res.ok?
    # assert_equal $morphdat, res.body
  end

  def test_route_sealifebase_morphmet
    res = fetch('sealifebase/morphmet')
    assert res.ok?
    # assert_equal $morphmet, res.body
  end

  def test_route_sealifebase_oxygen
    res = fetch('sealifebase/oxygen')
    assert res.ok?
    # assert_equal $oxygen, res.body
  end

  def test_route_sealifebase_popchar
    res = fetch('sealifebase/popchar')
    assert res.ok?
    # assert_equal $popchar, res.body
  end

  def test_route_sealifebase_popgrowth
    res = fetch('sealifebase/popgrowth')
    assert res.ok?
    # assert_equal $popgrowth, res.body
  end

  def test_route_sealifebase_poplf
    res = fetch('sealifebase/poplf')
    assert res.ok?
    # assert_equal $poplf, res.body
  end

  def test_route_sealifebase_popll
    res = fetch('sealifebase/popll')
    assert res.ok?
    # assert_equal $popll, res.body
  end

  def test_route_sealifebase_popqb
    res = fetch('sealifebase/popqb')
    assert res.ok?
    # assert_equal $popqb, res.body
  end

  def test_route_sealifebase_poplw
    res = fetch('sealifebase/poplw')
    assert res.ok?
    # assert_equal $poplw, res.body
  end

  def test_route_sealifebase_predats
    res = fetch('sealifebase/predats')
    assert res.ok?
    # assert_equal $predats, res.body
  end

  def test_route_sealifebase_ration
    res = fetch('sealifebase/ration')
    assert res.ok?
    # assert_equal $ration, res.body
  end

  def test_route_sealifebase_refrens
    res = fetch('sealifebase/refrens')
    assert res.ok?
    # assert_equal $refrens, res.body
  end

  def test_route_sealifebase_reproduc
    res = fetch('sealifebase/reproduc')
    assert res.ok?
    # assert_equal $reproduc, res.body
  end

  def test_route_sealifebase_species
    res = fetch('sealifebase/species')
    assert res.ok?
    # assert_equal $species, res.body
  end

  def test_route_sealifebase_spawning
    res = fetch('sealifebase/spawning')
    assert res.ok?
    # assert_equal $spawning, res.body
  end

  def test_route_sealifebase_speed
    res = fetch('sealifebase/speed')
    assert res.ok?
    # assert_equal $speed, res.body
  end

  def test_route_sealifebase_stocks
    res = fetch('sealifebase/stocks')
    assert res.ok?
    # assert_equal $stocks, res.body
  end

  def test_route_sealifebase_swimming
    res = fetch('sealifebase/swimming')
    assert res.ok?
    # assert_equal $swimming, res.body
  end

  def test_route_sealifebase_synonyms
    res = fetch('sealifebase/synonyms')
    assert res.ok?
    # assert_equal $synonyms, res.body
  end

  def test_route_sealifebase_taxa
    res = fetch('sealifebase/taxa')
    assert res.ok?
    # assert_equal $taxa, res.body
  end

end

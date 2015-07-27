require File.expand_path 'test_fxns.rb'

require 'minitest/autorun'
require 'httparty'
require 'json'

class RemoteRoutes < MiniTest::Test

  def test_route_root
    res = fetch()
    assert res.ok?
    assert 302, res.code
  end

  def test_route_docs
    res = fetch('docs')
    assert res.ok?
  end

  def test_route_docs_species
    res = fetch('docs/species')
    assert res.ok?
  end

  def test_route_heartbeat
    res = fetch('heartbeat')
    assert res.ok?
  end

  def test_route_mysqlping
    res = fetch('mysqlping')
    assert res.ok?
    assert_equal true, JSON.parse(res.body)['mysql_server_up']
  end

  def test_route_comnames
    res = fetch('comnames')
    assert res.ok?
  end

  def test_route_countref
    res = fetch('countref')
    assert res.ok?

    res = fetch('countref?SpecCode=24&fields=GrowthCountFresh,ABB')
    assert res.ok?
  end

  def test_route_country
    res = fetch('country')
    assert res.ok?
  end

  def test_route_diet
    res = fetch('diet')
    assert res.ok?
  end

  def test_route_ecology
    res = fetch('ecology')
    assert res.ok?
  end

  def test_route_ecosystem
    res = fetch('ecosystem')
    assert res.ok?
  end

  def test_route_faoareas
    res = fetch('faoareas')
    assert res.ok?
  end

  def test_route_faoarref
    res = fetch('faoarref')
    assert res.ok?
    # assert_equal $faoarref, res.body
  end

  def test_route_fecundity
    res = fetch('fecundity')
    assert res.ok?
    # assert_equal $fecundity, res.body
  end

  def test_route_fooditems
    res = fetch('fooditems')
    assert res.ok?
    # assert_equal $fooditems, res.body
  end

  def test_route_genera
    res = fetch('genera')
    assert res.ok?
    # assert_equal $genera, res.body
  end

  def test_route_intrcase
    res = fetch('intrcase')
    assert res.ok?
    # assert_equal $intrcase, res.body
  end

  def test_route_listfields
    res = fetch('listfields')
    assert res.ok?
    # assert_equal $intrcase, res.body
  end

  def test_route_maturity
    res = fetch('maturity')
    assert res.ok?
    # assert_equal $maturity, res.body
  end

  def test_route_morphdat
    res = fetch('morphdat')
    assert res.ok?
    # assert_equal $morphdat, res.body
  end

  def test_route_morphmet
    res = fetch('morphmet')
    assert res.ok?
    # assert_equal $morphmet, res.body
  end

  def test_route_oxygen
    res = fetch('oxygen')
    assert res.ok?
    # assert_equal $oxygen, res.body
  end

  def test_route_popchar
    res = fetch('popchar')
    assert res.ok?
    # assert_equal $popchar, res.body
  end

  def test_route_popgrowth
    res = fetch('popgrowth')
    assert res.ok?
    # assert_equal $popgrowth, res.body
  end

  def test_route_poplf
    res = fetch('poplf')
    assert res.ok?
    # assert_equal $poplf, res.body
  end

  def test_route_popll
    res = fetch('popll')
    assert res.ok?
    # assert_equal $popll, res.body
  end

  def test_route_popqb
    res = fetch('popqb')
    assert res.ok?
    # assert_equal $popqb, res.body
  end

  def test_route_poplw
    res = fetch('poplw')
    assert res.ok?
    # assert_equal $poplw, res.body
  end

  def test_route_predats
    res = fetch('predats')
    assert res.ok?
    # assert_equal $predats, res.body
  end

  def test_route_ration
    res = fetch('ration')
    assert res.ok?
    # assert_equal $ration, res.body
  end

  def test_route_refrens
    res = fetch('refrens')
    assert res.ok?
    # assert_equal $refrens, res.body
  end

  def test_route_reproduc
    res = fetch('reproduc')
    assert res.ok?
    # assert_equal $reproduc, res.body
  end

  def test_route_species
    res = fetch('species')
    assert res.ok?
    # assert_equal $species, res.body
  end

  def test_route_spawning
    res = fetch('spawning')
    assert res.ok?
    # assert_equal $spawning, res.body
  end

  def test_route_speed
    res = fetch('speed')
    assert res.ok?
    # assert_equal $speed, res.body
  end

  def test_route_stocks
    res = fetch('stocks')
    assert res.ok?
    # assert_equal $stocks, res.body
  end

  def test_route_swimming
    res = fetch('swimming')
    assert res.ok?
    # assert_equal $swimming, res.body
  end

  def test_route_synonyms
    res = fetch('synonyms')
    assert res.ok?
    # assert_equal $synonyms, res.body
  end

  def test_route_taxa
    res = fetch('taxa')
    assert res.ok?
    # assert_equal $taxa, res.body
  end

end

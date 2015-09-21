require File.expand_path 'test_helper_sealife.rb'
require File.expand_path 'test_fxns_local.rb'

require 'httparty'
require 'json'

class SLBAppRoutes < Minitest::Test

  include Rack::Test::Methods

  def app
    SLBApp
  end

  $slbheartbeat = "{\n  \"routes\": [\n    \"/docs/:table?\",\n    \"/heartbeat\",\n    \"/mysqlping\",\n    \"/comnames?<params>\",\n    \"/countref?<params>\",\n    \"/country?<params>\",\n    \"/diet?<params>\",\n    \"/ecology?<params>\",\n    \"/ecosystem?<params>\",\n    \"/faoareas/:id?<params>\",\n    \"/faoarref/:id?<params>\",\n    \"/fecundity?<params>\",\n    \"/fooditems?<params>\",\n    \"/genera/:id?<params>\",\n    \"/intrcase?<params>\",\n    \"/listfields?<params>\",\n    \"/maturity?<params>\",\n    \"/morphdat?<params>\",\n    \"/morphmet?<params>\",\n    \"/occurrence?<params>\",\n    \"/popchar?<params>\",\n    \"/popgrowth?<params>\",\n    \"/poplf?<params>\",\n    \"/popll?<params>\",\n    \"/popqb?<params>\",\n    \"/poplw?<params>\",\n    \"/predats?<params>\",\n    \"/ration?<params>\",\n    \"/refrens?<params>\",\n    \"/reproduc?<params>\",\n    \"/species/:id?<params>\",\n    \"/spawning?<params>\",\n    \"/speed?<params>\",\n    \"/stocks?<params>\",\n    \"/swimming?<params>\",\n    \"/synonyms?<params>\",\n    \"/taxa?<params>\"\n  ]\n}"

  def test_route_root
    res = fetch('sealifebase')
    assert res.ok?
    assert 302, res.code
  end

  def test_route_heartbeat
    res = fetch('/sealifebase/heartbeat')
    assert 200, res.code
    assert_equal $slbheartbeat, res.body
  end

  def test_route_mysqlping
    res = fetch('/sealifebase/mysqlping')
    assert 200, res.code
    assert_equal true, JSON.parse(res.body)['mysql_server_up']
  end

  def test_route_comnames
    res = fetch('/sealifebase/comnames')
    assert 200, res.code
    assert_equal 10, JSON.parse(res.body)['returned']
  end

  def test_route_countref
    res = fetch('/sealifebase/countref')
    assert 200, res.code
    assert_equal 10, JSON.parse(res.body)['returned']

    res = fetch('/sealifebase/countref?SpecCode=24&fields=GrowthCountFresh,ABB')
    assert 200, res.code
    # JSON.parse(last_response.body)['data']
    # assert_equal $countref, JSON.parse(last_response.body)['data']
  end

  def test_route_country
    res = fetch('/sealifebase/country')
    assert 200, res.code
    # assert_equal $country, last_response.body
  end

  def test_route_diet
    res = fetch('/sealifebase/diet')
    assert 200, res.code
    # assert_equal $diet, last_response.body
  end

  def test_route_docs
    res = fetch('/sealifebase/docs')
    assert 200, res.code

    res = fetch('/sealifebase/docs/species')
    assert 200, res.code

    res = fetch('/sealifebase/docs/countref')
    assert 200, res.code

    # bad route
    res = fetch('/sealifebase/docs/foobar')
    assert 400, res.code
  end

  def test_route_ecology
    res = fetch('/sealifebase/ecology')
    assert 200, res.code
    # assert_equal $ecology, last_response.body
  end

  def test_route_ecosystem
    res = fetch('/sealifebase/ecosystem')
    assert 200, res.code
    # assert_equal $ecosystem, last_response.body
  end

  def test_route_faoareas
    res = fetch('/sealifebase/faoareas')
    assert 200, res.code
    # assert_equal $faoareas, last_response.body
  end

  def test_route_faoarref
    res = fetch('/sealifebase/faoarref')
    assert 200, res.code
    # assert_equal $faoarref, last_response.body
  end

  def test_route_fecundity
    res = fetch('/sealifebase/fecundity')
    assert 200, res.code
    assert (res['data'][0].keys & ['FecundityMax']).any?
  end

  def test_route_fooditems
    res = fetch('/sealifebase/fooditems')
    assert 200, res.code
    assert (res['data'][0].keys & ['Foodname']).any?
  end

  def test_route_genera
    res = fetch('/sealifebase/genera')
    assert 200, res.code
    assert (res['data'][0].keys & ['GEN_NAME']).any?
  end

  def test_route_intrcase
    res = fetch('/sealifebase/intrcase')
    assert 200, res.code
    assert (res['data'][0].keys & ['IntrCaseRefNo']).any?
  end

  def test_route_listfields
    res = fetch('/sealifebase/listfields')
    assert 200, res.code
    assert (res['data'][0].keys & ['TABLE_NAME','COLUMN_NAME']).any?
  end

  def test_route_maturity
    res = fetch('/sealifebase/maturity')
    assert 200, res.code
    assert (res['data'][0].keys & ['MaturityRefNo','AgeMatMin']).any?
  end

  def test_route_morphdat
    res = fetch('/sealifebase/morphdat')
    assert 200, res.code
    assert (res['data'][0].keys & ['MorphDatRefNo','TypeofEyes']).any?
  end

  def test_route_morphmet
    res = fetch('/sealifebase/morphmet')
    assert 200, res.code
    assert (res['data'][0].keys & ['MorphDatRefNo','TypeofEyes']).any?
  end

  def test_route_popchar
    res = fetch('/sealifebase/popchar')
    assert 200, res.code
    assert (res['data'][0].keys & ['PopCharRefNo']).any?
  end

  # # $popgrowth =
  # def test_route_popgrowth
  #   get '/popgrowth'
  #   assert last_response.ok?
  #   # assert_equal $popgrowth, last_response.body
  # end

  # # $poplf =
  # def test_route_poplf
  #   get '/poplf'
  #   assert last_response.ok?
  #   # assert_equal $poplf, last_response.body
  # end

  # # $popll =
  # def test_route_popll
  #   get '/popll'
  #   assert last_response.ok?
  #   # assert_equal $popll, last_response.body
  # end

  # # $popqb =
  # def test_route_popqb
  #   get '/popqb'
  #   assert last_response.ok?
  #   # assert_equal $popqb, last_response.body
  # end

  # # $poplw =
  # def test_route_poplw
  #   get '/poplw'
  #   assert last_response.ok?
  #   # assert_equal $poplw, last_response.body
  # end

  # # $predats =
  # def test_route_predats
  #   get '/predats'
  #   assert last_response.ok?
  #   # assert_equal $predats, last_response.body
  # end

  # # $ration =
  # def test_route_ration
  #   get '/ration'
  #   assert last_response.ok?
  #   # assert_equal $ration, last_response.body
  # end

  # # $refrens =
  # def test_route_refrens
  #   get '/refrens'
  #   assert last_response.ok?
  #   # assert_equal $refrens, last_response.body
  # end

  # # $reproduc =
  # def test_route_reproduc
  #   get '/reproduc'
  #   assert last_response.ok?
  #   # assert_equal $reproduc, last_response.body
  # end

  # # $species =
  # def test_route_species
  #   get '/species'
  #   assert last_response.ok?
  #   # assert_equal $species, last_response.body
  # end

  # # $spawning =
  # def test_route_spawning
  #   get '/spawning'
  #   assert last_response.ok?
  #   # assert_equal $spawning, last_response.body
  # end

  # # $speed =
  # def test_route_speed
  #   get '/speed'
  #   assert last_response.ok?
  #   # assert_equal $speed, last_response.body
  # end

  # # $stocks =
  # def test_route_stocks
  #   get '/stocks'
  #   assert last_response.ok?
  #   # assert_equal $stocks, last_response.body
  # end

  # # $swimming =
  # def test_route_swimming
  #   get '/swimming'
  #   assert last_response.ok?
  #   # assert_equal $swimming, last_response.body
  # end

  # # $synonyms =
  # def test_route_synonyms
  #   get '/synonyms'
  #   assert last_response.ok?
  #   # assert_equal $synonyms, last_response.body
  # end

  # # $taxa =
  # def test_route_taxa
  #   get '/taxa'
  #   assert last_response.ok?
  #   # assert_equal $taxa, last_response.body
  # end

end

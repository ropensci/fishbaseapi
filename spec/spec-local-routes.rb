require File.expand_path 'test_helper.rb'

class FBAppRoutes < Minitest::Test

  include Rack::Test::Methods

  def app
    FBApp
  end

  $heartbeat = "{\n  \"routes\": [\n    \"/docs\",\n    \"/heartbeat\",\n    \"/mysqlping\",\n    \"/comnames?<params>\",\n    \"/countref?<params>\",\n    \"/country?<params>\",\n    \"/diet?<params>\",\n    \"/ecology?<params>\",\n    \"/ecosystem?<params>\",\n    \"/faoareas/:id?<params>\",\n    \"/faoarref/:id?<params>\",\n    \"/fecundity?<params>\",\n    \"/fooditems?<params>\",\n    \"/genera/:id?<params>\",\n    \"/intrcase?<params>\",\n    \"/listfields?<params>\",\n    \"/maturity?<params>\",\n    \"/morphdat?<params>\",\n    \"/morphmet?<params>\",\n    \"/occurrence?<params>\",\n    \"/oxygen?<params>\",\n    \"/popchar?<params>\",\n    \"/popgrowth?<params>\",\n    \"/poplf?<params>\",\n    \"/popll?<params>\",\n    \"/popqb?<params>\",\n    \"/poplw?<params>\",\n    \"/predats?<params>\",\n    \"/ration?<params>\",\n    \"/refrens?<params>\",\n    \"/reproduc?<params>\",\n    \"/species/:id?<params>\",\n    \"/spawning?<params>\",\n    \"/speed?<params>\",\n    \"/stocks?<params>\",\n    \"/swimming?<params>\",\n    \"/synonyms?<params>\",\n    \"/taxa?<params>\"\n  ]\n}"
  $countref = {"autoctr"=>851, "Stockcode"=>32, "C_Code"=>"428", "SpecCode"=>24, "CountryRefNo"=>188, "AlsoRef"=>nil, "Status"=>"native", "CurrentPresence"=>"present", "Freshwater"=>0, "Brackish"=>1, "Saltwater"=>0, "Comments"=>nil, "Abundance"=>nil, "RefAbundance"=>nil, "Importance"=>"commercial", "RefImportance"=>8984, "ExVesselPrice"=>2454.0215, "Aquaculture"=>"never/rarely", "RefAquaculture"=>nil, "LiveExportOrg"=>0, "LiveExport"=>nil, "RefLiveExport"=>nil, "Game"=>0, "Bait"=>0, "Regulations"=>nil, "RefRegulations"=>nil, "Threatened"=>0, "CountrySubComp"=>0, "Entered"=>2, "DateEntered"=>"1993-11-12 00:00:00 -0800", "Modified"=>1, "DateModified"=>"1999-03-22 00:00:00 -0800", "Expert"=>nil, "DateChecked"=>nil, "TS"=>nil}

  def test_route_root
    get '/'
    assert 302, last_response.status
  end

  def test_route_heartbeat
    get '/heartbeat'
    assert last_response.ok?
    assert_equal $heartbeat, last_response.body
  end

  # $mysqlping =
  def test_route_mysqlping
    get '/mysqlping'
    assert last_response.ok?
    assert_equal true, JSON.parse(last_response.body)['mysql_server_up']
  end

  # $comnames =
  def test_route_comnames
    get '/comnames'
    assert last_response.ok?
    assert_equal 10, JSON.parse(last_response.body)['returned']
  end

  # $countref =
  def test_route_countref
    get '/countref'
    assert last_response.ok?
    assert_equal 10, JSON.parse(last_response.body)['returned']

    get '/countref?SpecCode=24&fields=GrowthCountFresh,ABB'
    assert last_response.ok?
    # JSON.parse(last_response.body)['data']
    # assert_equal $countref, JSON.parse(last_response.body)['data']
  end

  # $country =
  def test_route_country
    get '/country'
    assert last_response.ok?
    # assert_equal $country, last_response.body
  end

  # $diet =
  def test_route_diet
    get '/diet'
    assert last_response.ok?
    # assert_equal $diet, last_response.body
  end

  # $ecology =
  def test_route_ecology
    get '/ecology'
    assert last_response.ok?
    # assert_equal $ecology, last_response.body
  end

  # $ecosystem =
  def test_route_ecosystem
    get '/ecosystem'
    assert last_response.ok?
    # assert_equal $ecosystem, last_response.body
  end

  # $faoareas =
  def test_route_faoareas
    get '/faoareas'
    assert last_response.ok?
    # assert_equal $faoareas, last_response.body
  end

  # $faoarref =
  def test_route_faoarref
    get '/faoarref'
    assert last_response.ok?
    # assert_equal $faoarref, last_response.body
  end

  # $fecundity =
  def test_route_fecundity
    get '/fecundity'
    assert last_response.ok?
    # assert_equal $fecundity, last_response.body
  end

  # $fooditems =
  def test_route_fooditems
    get '/fooditems'
    assert last_response.ok?
    # assert_equal $fooditems, last_response.body
  end

  # $genera =
  def test_route_genera
    get '/genera'
    assert last_response.ok?
    # assert_equal $genera, last_response.body
  end

  # $intrcase =
  def test_route_intrcase
    get '/intrcase'
    assert last_response.ok?
    # assert_equal $intrcase, last_response.body
  end

  # $listfields =
  def test_route_listfields
    get '/listfields'
    assert last_response.ok?
    # assert_equal $listfields, last_response.body
  end

  # $maturity =
  def test_route_maturity
    get '/maturity'
    assert last_response.ok?
    # assert_equal $maturity, last_response.body
  end

  # $morphdat =
  def test_route_morphdat
    get '/morphdat'
    assert last_response.ok?
    # assert_equal $morphdat, last_response.body
  end

  # $morphmet =
  def test_route_morphmet
    get '/morphmet'
    assert last_response.ok?
    # assert_equal $morphmet, last_response.body
  end

  # $oxygen =
  def test_route_oxygen
    get '/oxygen'
    assert last_response.ok?
    # assert_equal $oxygen, last_response.body
  end

  # $popchar =
  def test_route_popchar
    get '/popchar'
    assert last_response.ok?
    # assert_equal $popchar, last_response.body
  end

  # $popgrowth =
  def test_route_popgrowth
    get '/popgrowth'
    assert last_response.ok?
    # assert_equal $popgrowth, last_response.body
  end

  # $poplf =
  def test_route_poplf
    get '/poplf'
    assert last_response.ok?
    # assert_equal $poplf, last_response.body
  end

  # $popll =
  def test_route_popll
    get '/popll'
    assert last_response.ok?
    # assert_equal $popll, last_response.body
  end

  # $popqb =
  def test_route_popqb
    get '/popqb'
    assert last_response.ok?
    # assert_equal $popqb, last_response.body
  end

  # $poplw =
  def test_route_poplw
    get '/poplw'
    assert last_response.ok?
    # assert_equal $poplw, last_response.body
  end

  # $predats =
  def test_route_predats
    get '/predats'
    assert last_response.ok?
    # assert_equal $predats, last_response.body
  end

  # $ration =
  def test_route_ration
    get '/ration'
    assert last_response.ok?
    # assert_equal $ration, last_response.body
  end

  # $refrens =
  def test_route_refrens
    get '/refrens'
    assert last_response.ok?
    # assert_equal $refrens, last_response.body
  end

  # $reproduc =
  def test_route_reproduc
    get '/reproduc'
    assert last_response.ok?
    # assert_equal $reproduc, last_response.body
  end

  # $species =
  def test_route_species
    get '/species'
    assert last_response.ok?
    # assert_equal $species, last_response.body
  end

  # $spawning =
  def test_route_spawning
    get '/spawning'
    assert last_response.ok?
    # assert_equal $spawning, last_response.body
  end

  # $speed =
  def test_route_speed
    get '/speed'
    assert last_response.ok?
    # assert_equal $speed, last_response.body
  end

  # $stocks =
  def test_route_stocks
    get '/stocks'
    assert last_response.ok?
    # assert_equal $stocks, last_response.body
  end

  # $swimming =
  def test_route_swimming
    get '/swimming'
    assert last_response.ok?
    # assert_equal $swimming, last_response.body
  end

  # $synonyms =
  def test_route_synonyms
    get '/synonyms'
    assert last_response.ok?
    # assert_equal $synonyms, last_response.body
  end

  # $taxa =
  def test_route_taxa
    get '/taxa'
    assert last_response.ok?
    # assert_equal $taxa, last_response.body
  end

end

require File.expand_path 'test_fxns.rb'

require 'minitest/autorun'
require 'httparty'
require 'json'

class RemoteRoutes < MiniTest::Test

  $heartbeat = "{\n  \"routes\": [\n    \"/docs\",\n    \"/heartbeat\",\n    \"/mysqlping\",\n    \"/comnames?<params>\",\n    \"/countref?<params>\",\n    \"/country?<params>\",\n    \"/diet?<params>\",\n    \"/ecology?<params>\",\n    \"/ecosystem?<params>\",\n    \"/faoareas/:id?<params>\",\n    \"/faoarref/:id?<params>\",\n    \"/fecundity?<params>\",\n    \"/fooditems?<params>\",\n    \"/genera/:id?<params>\",\n    \"/intrcase?<params>\",\n    \"/listfields?<params>\",\n    \"/maturity?<params>\",\n    \"/morphdat?<params>\",\n    \"/morphmet?<params>\",\n    \"/occurrence?<params>\",\n    \"/oxygen?<params>\",\n    \"/popchar?<params>\",\n    \"/popgrowth?<params>\",\n    \"/poplf?<params>\",\n    \"/popll?<params>\",\n    \"/popqb?<params>\",\n    \"/poplw?<params>\",\n    \"/predats?<params>\",\n    \"/ration?<params>\",\n    \"/refrens?<params>\",\n    \"/reproduc?<params>\",\n    \"/species/:id?<params>\",\n    \"/spawning?<params>\",\n    \"/speed?<params>\",\n    \"/stocks?<params>\",\n    \"/swimming?<params>\",\n    \"/synonyms?<params>\",\n    \"/taxa?<params>\"\n  ]\n}"
  $countref = {"GrowthCountFresh"=>38, "ABB"=>"AFG"}
  $country = {"autoctr"=>851, "Stockcode"=>32, "C_Code"=>"428", "SpecCode"=>24, "CountryRefNo"=>188, "AlsoRef"=>nil, "Status"=>"native", "CurrentPresence"=>"present", "Freshwater"=>0, "Brackish"=>1, "Saltwater"=>0, "Land"=>0, "Comments"=>nil, "Abundance"=>nil, "RefAbundance"=>nil, "Importance"=>"commercial", "RefImportance"=>8984, "ExVesselPrice"=>2454.0215, "Aquaculture"=>nil, "RefAquaculture"=>nil, "LiveExportOrg"=>0, "LiveExport"=>nil, "RefLiveExport"=>nil, "Game"=>0, "Bait"=>0, "Regulations"=>nil, "RefRegulations"=>nil, "Threatened"=>0, "CountrySubComp"=>0, "Entered"=>2, "DateEntered"=>"1993-11-12 00:00:00 +0000", "Modified"=>1, "DateModified"=>"1999-03-22 00:00:00 +0000", "Expert"=>nil, "DateChecked"=>nil, "TS"=>nil}
  $diet = {"DietCode"=>1, "StockCode"=>79, "Speccode"=>69, "DietRefNo"=>9604, "SampleStage"=>"recruits/juv.", "SampleSize"=>37, "YearStart"=>nil, "YearEnd"=>nil, "January"=>0, "February"=>0, "March"=>0, "April"=>-1, "May"=>-1, "June"=>-1, "July"=>0, "August"=>0, "September"=>0, "October"=>0, "November"=>0, "December"=>0, "C_Code"=>"826", "Locality"=>"Off the west coast of the Isle of Man, 1977-1978", "E_Code"=>235, "Method"=>nil, "MethodType"=>nil, "Remark"=>"Length type derived from given length in Species table.", "OtherItems"=>0.1, "PercentEmpty"=>nil, "Troph"=>3.83, "seTroph"=>0.37, "SizeMin"=>30.0, "SizeMax"=>39.0, "SizeType"=>"TL", "FishLength"=>34.5, "Entered"=>34, "DateEntered"=>"1995-07-29 00:00:00 +0000", "Modified"=>nil, "DateModified"=>"2010-12-17 00:00:00 +0000", "Expert"=>nil, "DateChecked"=>nil}
  $ecosystem = {"autoctr"=>1, "E_CODE"=>1, "EcosystemRefno"=>50628, "Speccode"=>549, "Stockcode"=>565, "Status"=>"native", "Abundance"=>nil, "LifeStage"=>"adults", "Remarks"=>nil, "Entered"=>10, "Dateentered"=>"2007-11-12 00:00:00 +0000", "Modified"=>nil, "Datemodified"=>"2007-11-12 00:00:00 +0000", "Expert"=>nil, "Datechecked"=>nil, "WebURL"=>nil, "TS"=>nil}
  $faoareas = {"autoctr"=>483, "AreaCode"=>1, "SpecCode"=>2, "StockCode"=>1, "Status"=>"endemic", "Entered"=>2, "DateEntered"=>"1990-10-19 00:00:00 +0000", "Modified"=>675, "DateModified"=>"2011-02-11 17:16:45 +0000", "Expert"=>nil, "DateChecked"=>nil, "TS"=>nil}

  def test_route_root
    res = fetch()
    assert res.ok?
    assert 302, res.code
  end

  def test_route_heartbeat
    res = fetch('heartbeat')
    assert res.ok?
    assert_equal $heartbeat, res.body
  end

  def test_route_mysqlping
    res = fetch('mysqlping')
    assert res.ok?
    assert_equal true, JSON.parse(res.body)['mysql_server_up']
  end

  def test_route_comnames
    res = fetch('comnames')
    assert res.ok?
    assert_equal 10, JSON.parse(res.body)['returned']
  end

  def test_route_countref
    res = fetch('countref')
    assert res.ok?
    assert_equal 10, JSON.parse(res.body)['returned']

    res = fetch('countref?SpecCode=24&fields=GrowthCountFresh,ABB')
    assert res.ok?
    assert_equal $countref, JSON.parse(res.body)['data'][0]
  end

  def test_route_country
    res = fetch('country')
    assert res.ok?
    assert_equal $country, JSON.parse(res.body)['data'][0]
  end

  def test_route_diet
    res = fetch('diet')
    assert res.ok?
    assert_equal $diet, JSON.parse(res.body)['data'][0]
  end

  def test_route_ecology
    res = fetch('ecology')
    assert res.ok?
    assert_equal 4, JSON.parse(res.body).length
  end

  def test_route_ecosystem
    res = fetch('ecosystem')
    assert res.ok?
    assert_equal $ecosystem, JSON.parse(res.body)['data'][0]
  end

  def test_route_faoareas
    res = fetch('faoareas')
    assert res.ok?
    assert_equal $faoareas, JSON.parse(res.body)['data'][0]
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

require 'minitest/autorun'
require 'httparty'
require 'json'

class APITest < MiniTest::Test

  $heartbeat = "{\n  \"routes\": [\n    \"/docs\",\n    \"/heartbeat\",\n    \"/mysqlping\",\n    \"/comnames?<params>\",\n    \"/countref?<params>\",\n    \"/country?<params>\",\n    \"/diet?<params>\",\n    \"/ecology?<params>\",\n    \"/ecosystem?<params>\",\n    \"/faoareas/:id?<params>\",\n    \"/faoarref/:id?<params>\",\n    \"/fecundity?<params>\",\n    \"/fooditems?<params>\",\n    \"/genera/:id?<params>\",\n    \"/intrcase?<params>\",\n    \"/maturity?<params>\",\n    \"/morphdat?<params>\",\n    \"/morphmet?<params>\",\n    \"/occurrence?<params>\",\n    \"/oxygen?<params>\",\n    \"/popchar?<params>\",\n    \"/popgrowth?<params>\",\n    \"/poplf?<params>\",\n    \"/popll?<params>\",\n    \"/popqb?<params>\",\n    \"/poplw?<params>\",\n    \"/predats?<params>\",\n    \"/ration?<params>\",\n    \"/refrens?<params>\",\n    \"/reproduc?<params>\",\n    \"/species/:id?<params>\",\n    \"/spawning?<params>\",\n    \"/speed?<params>\",\n    \"/stocks?<params>\",\n    \"/swimming?<params>\",\n    \"/synonyms?<params>\",\n    \"/taxa?<params>\"\n  ]\n}"
  $comnames = {"autoctr"=>236404, "ComName"=>" ???????", "Transliteration"=>"Varimeen", "StockCode"=>135, "SpecCode"=>121, "C_Code"=>"356", "Language"=>"Telugu", "Script"=>"Telugu", "UnicodeText"=>"&#160;&#3125;&#3120;&#3135;&#3118;&#3142;&#3112;&#3149;", "NameType"=>"Vernacular", "PreferredName"=>0, "TradeName"=>0, "TradeNameRef"=>nil, "ComNamesRefNo"=>nil, "Misspelling"=>0, "Size"=>"juveniles and adults", "Sex"=>"females and males", "Language2"=>nil, "Locality2"=>nil, "Rank"=>3, "Remarks"=>nil, "SecondWord"=>nil, "ThirdWord"=>nil, "FourthWord"=>nil, "Entered"=>1029, "DateEntered"=>"2005-07-22 00:00:00 +0000", "Modified"=>393, "DateModified"=>"2011-07-27 00:00:00 +0000", "Expert"=>1432, "DateChecked"=>"2005-07-22 00:00:00 +0000", "Core"=>nil, "modifier1"=>nil, "modifier2"=>nil, "CLOFFSCA"=>0}
  $countref = {"GrowthCountFresh"=>38, "ABB"=>"AFG"}
  $country = {"autoctr"=>851, "Stockcode"=>32, "C_Code"=>"428", "SpecCode"=>24, "CountryRefNo"=>188, "AlsoRef"=>nil, "Status"=>"native", "CurrentPresence"=>"present", "Freshwater"=>0, "Brackish"=>1, "Saltwater"=>0, "Land"=>0, "Comments"=>nil, "Abundance"=>nil, "RefAbundance"=>nil, "Importance"=>"commercial", "RefImportance"=>8984, "ExVesselPrice"=>2454.0215, "Aquaculture"=>nil, "RefAquaculture"=>nil, "LiveExportOrg"=>0, "LiveExport"=>nil, "RefLiveExport"=>nil, "Game"=>0, "Bait"=>0, "Regulations"=>nil, "RefRegulations"=>nil, "Threatened"=>0, "CountrySubComp"=>0, "Entered"=>2, "DateEntered"=>"1993-11-12 00:00:00 +0000", "Modified"=>1, "DateModified"=>"1999-03-22 00:00:00 +0000", "Expert"=>nil, "DateChecked"=>nil, "TS"=>nil}
  $diet = {"DietCode"=>1, "StockCode"=>79, "Speccode"=>69, "DietRefNo"=>9604, "SampleStage"=>"recruits/juv.", "SampleSize"=>37, "YearStart"=>nil, "YearEnd"=>nil, "January"=>0, "February"=>0, "March"=>0, "April"=>-1, "May"=>-1, "June"=>-1, "July"=>0, "August"=>0, "September"=>0, "October"=>0, "November"=>0, "December"=>0, "C_Code"=>"826", "Locality"=>"Off the west coast of the Isle of Man, 1977-1978", "E_Code"=>235, "Method"=>nil, "MethodType"=>nil, "Remark"=>"Length type derived from given length in Species table.", "OtherItems"=>0.1, "PercentEmpty"=>nil, "Troph"=>3.83, "seTroph"=>0.37, "SizeMin"=>30.0, "SizeMax"=>39.0, "SizeType"=>"TL", "FishLength"=>34.5, "Entered"=>34, "DateEntered"=>"1995-07-29 00:00:00 +0000", "Modified"=>nil, "DateModified"=>"2010-12-17 00:00:00 +0000", "Expert"=>nil, "DateChecked"=>nil}

  # setup
  def fetch(route = '')
    response = HTTParty.get("http://fishbase.ropensci.org/" + route)
    return response
  end

  # tests
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
    assert_equal $comnames, JSON.parse(res.body)['data'][0]
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

  # def test_route_root
  #   res = fetch("species/5")
  #   data = JSON.parse res.body
  #   assert 1, data['returned']
  # end
end

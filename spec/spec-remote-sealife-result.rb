require File.expand_path 'test_fxns.rb'

require 'minitest/autorun'
require 'httparty'
require 'json'

class RemoteResultsSealife < Minitest::Test

  $sealifeheartbeat = "{\n  \"routes\": [\n    \"/docs/:table?\",\n    \"/heartbeat\",\n    \"/mysqlping\",\n    \"/comnames?<params>\",\n    \"/countref?<params>\",\n    \"/country?<params>\",\n    \"/diet?<params>\",\n    \"/ecology?<params>\",\n    \"/ecosystem?<params>\",\n    \"/faoareas/:id?<params>\",\n    \"/faoarref/:id?<params>\",\n    \"/fecundity?<params>\",\n    \"/fooditems?<params>\",\n    \"/genera/:id?<params>\",\n    \"/intrcase?<params>\",\n    \"/listfields?<params>\",\n    \"/maturity?<params>\",\n    \"/morphdat?<params>\",\n    \"/morphmet?<params>\",\n    \"/occurrence?<params>\",\n    \"/oxygen?<params>\",\n    \"/popchar?<params>\",\n    \"/popgrowth?<params>\",\n    \"/poplf?<params>\",\n    \"/popll?<params>\",\n    \"/popqb?<params>\",\n    \"/poplw?<params>\",\n    \"/predats?<params>\",\n    \"/ration?<params>\",\n    \"/refrens?<params>\",\n    \"/reproduc?<params>\",\n    \"/species/:id?<params>\",\n    \"/spawning?<params>\",\n    \"/speed?<params>\",\n    \"/stocks?<params>\",\n    \"/swimming?<params>\",\n    \"/synonyms?<params>\",\n    \"/taxa?<params>\"\n  ]\n}"
  $sealifespecies5 = "{\n  \"count\": 1,\n  \"returned\": 1,\n  \"error\": null,\n  \"data\": [\n    {\n      \"SpecCode\": 5,\n      \"Genus\": \"Orthopristis\",\n      \"Species\": \"chrysoptera\",\n      \"SpeciesRefNo\": 25,\n      \"Author\": \"(Linnaeus, 1766)\",\n      \"FBname\": \"Pigfish\",\n      \"PicPreferredName\": \"Orchr_u0.jpg\",\n      \"PicPreferredNameM\": null,\n      \"PicPreferredNameF\": null,\n      \"PicPreferredNameJ\": null,\n      \"FamCode\": 327,\n      \"Subfamily\": \"Haemulinae\",\n      \"GenCode\": 1542,\n      \"SubGenCode\": null,\n      \"BodyShapeI\": \"short and / or deep\",\n      \"Source\": \"O\",\n      \"Remark\": null,\n      \"TaxIssue\": 0,\n      \"Fresh\": 0,\n      \"Brack\": -1,\n      \"Saltwater\": -1,\n      \"DemersPelag\": \"demersal\",\n      \"AnaCat\": \"oceanodromous\",\n      \"MigratRef\": 51243,\n      \"DepthRangeShallow\": 10,\n      \"DepthRangeDeep\": null,\n      \"DepthRangeRef\": 25,\n      \"DepthRangeComShallow\": null,\n      \"DepthRangeComDeep\": null,\n      \"DepthComRef\": null,\n      \"LongevityWild\": 4.0,\n      \"LongevityWildRef\": 25,\n      \"LongevityCaptive\": null,\n      \"LongevityCapRef\": null,\n      \"Vulnerability\": 50.68,\n      \"Length\": 46.0,\n      \"LTypeMaxM\": \"SL\",\n      \"LengthFemale\": null,\n      \"LTypeMaxF\": null,\n      \"MaxLengthRef\": 25,\n      \"CommonLength\": 30.0,\n      \"LTypeComM\": \"TL\",\n      \"CommonLengthF\": null,\n      \"LTypeComF\": null,\n      \"CommonLengthRef\": 3798,\n      \"Weight\": 900.0,\n      \"WeightFemale\": null,\n      \"MaxWeightRef\": 25,\n      \"Pic\": \"ORCHR_U0\",\n      \"PictureFemale\": null,\n      \"LarvaPic\": null,\n      \"EggPic\": null,\n      \"ImportanceRef\": 181,\n      \"Importance\": \"minor commercial\",\n      \"PriceCateg\": \"low\",\n      \"PriceReliability\": \"Reliable: based on ex-vessel price for this species\",\n      \"Remarks7\": null,\n      \"LandingStatistics\": \"up to 1,000 tons/year\",\n      \"Landings\": \"North Carolina, USA (Area 21)\",\n      \"MainCatchingMethod\": \"seines\",\n      \"II\": \"unspecified seines (SX)\",\n      \"MSeines\": -1,\n      \"MGillnets\": 0,\n      \"MCastnets\": 0,\n      \"MTraps\": -1,\n      \"MSpears\": 0,\n      \"MTrawls\": -1,\n      \"MDredges\": 0,\n      \"MLiftnets\": 0,\n      \"MHooksLines\": -1,\n      \"MOther\": 0,\n      \"UsedforAquaculture\": \"never/rarely\",\n      \"LifeCycle\": null,\n      \"AquacultureRef\": null,\n      \"UsedasBait\": \"usually\",\n      \"BaitRef\": 25,\n      \"Aquarium\": \"public aquariums\",\n      \"AquariumFishII\": \"based mainly on capture\",\n      \"AquariumRef\": 7251,\n      \"GameFish\": 0,\n      \"GameRef\": null,\n      \"Dangerous\": \"harmless\",\n      \"DangerousRef\": null,\n      \"Electrogenic\": \"no special ability\",\n      \"ElectroRef\": null,\n      \"Complete\": null,\n      \"GoogleImage\": -1,\n      \"Comments\": \"Inhabits coastal waters, over sand and mud bottoms.  Forms schools.  Mainly nocturnal and non-burrowing.  Feeds on crustaceans and smaller fishes.  Undergoes seasonal migration as well as local nocturnal-diurnal foraging migrations (Ref. 25).\",\n      \"Profile\": null,\n      \"PD50\": 0.5078,\n      \"Entered\": 1,\n      \"DateEntered\": \"1990-10-17 00:00:00 -0700\",\n      \"Modified\": 393,\n      \"DateModified\": \"2000-09-25 00:00:00 -0700\",\n      \"Expert\": 34,\n      \"DateChecked\": \"1995-08-25 00:00:00 -0700\",\n      \"TS\": null\n    }\n  ]\n}"
  $sealifespecies = "{\n  \"count\": 32792,\n  \"returned\": 1,\n  \"error\": null,\n  \"data\": [\n    {\n      \"SpecCode\": 16239,\n      \"Genus\": \"Aaptosyax\",\n      \"Species\": \"grypus\",\n      \"SpeciesRefNo\": 10431,\n      \"Author\": \"Rainboth, 1991\",\n      \"FBname\": \"Giant salmon carp\",\n      \"PicPreferredName\": \"Aagry_u0.gif\",\n      \"PicPreferredNameM\": null,\n      \"PicPreferredNameF\": null,\n      \"PicPreferredNameJ\": null,\n      \"FamCode\": 122,\n      \"Subfamily\": \"No subfamily\",\n      \"GenCode\": 10273,\n      \"SubGenCode\": null,\n      \"BodyShapeI\": \"fusiform / normal\",\n      \"Source\": \"O\",\n      \"Remark\": null,\n      \"TaxIssue\": 12,\n      \"Fresh\": -1,\n      \"Brack\": 0,\n      \"Saltwater\": 0,\n      \"DemersPelag\": \"pelagic\",\n      \"AnaCat\": \"potamodromous\",\n      \"MigratRef\": 51243,\n      \"DepthRangeShallow\": null,\n      \"DepthRangeDeep\": null,\n      \"DepthRangeRef\": null,\n      \"DepthRangeComShallow\": null,\n      \"DepthRangeComDeep\": null,\n      \"DepthComRef\": null,\n      \"LongevityWild\": null,\n      \"LongevityWildRef\": null,\n      \"LongevityCaptive\": null,\n      \"LongevityCapRef\": null,\n      \"Vulnerability\": 80.31,\n      \"Length\": 130.0,\n      \"LTypeMaxM\": \"SL\",\n      \"LengthFemale\": null,\n      \"LTypeMaxF\": null,\n      \"MaxLengthRef\": 9497,\n      \"CommonLength\": null,\n      \"LTypeComM\": null,\n      \"CommonLengthF\": null,\n      \"LTypeComF\": null,\n      \"CommonLengthRef\": null,\n      \"Weight\": 30000.0,\n      \"WeightFemale\": null,\n      \"MaxWeightRef\": 9497,\n      \"Pic\": null,\n      \"PictureFemale\": null,\n      \"LarvaPic\": null,\n      \"EggPic\": null,\n      \"ImportanceRef\": 10431,\n      \"Importance\": null,\n      \"PriceCateg\": \"unknown\",\n      \"PriceReliability\": null,\n      \"Remarks7\": null,\n      \"LandingStatistics\": \" \",\n      \"Landings\": null,\n      \"MainCatchingMethod\": \"gillnets\",\n      \"II\": \" \",\n      \"MSeines\": -1,\n      \"MGillnets\": -1,\n      \"MCastnets\": -1,\n      \"MTraps\": 0,\n      \"MSpears\": 0,\n      \"MTrawls\": 0,\n      \"MDredges\": 0,\n      \"MLiftnets\": 0,\n      \"MHooksLines\": -1,\n      \"MOther\": -1,\n      \"UsedforAquaculture\": \"never/rarely\",\n      \"LifeCycle\": \" \",\n      \"AquacultureRef\": null,\n      \"UsedasBait\": \"never/rarely\",\n      \"BaitRef\": null,\n      \"Aquarium\": \"never/rarely\",\n      \"AquariumFishII\": \" \",\n      \"AquariumRef\": null,\n      \"GameFish\": 0,\n      \"GameRef\": null,\n      \"Dangerous\": \"harmless\",\n      \"DangerousRef\": null,\n      \"Electrogenic\": \"no special ability\",\n      \"ElectroRef\": null,\n      \"Complete\": null,\n      \"GoogleImage\": -1,\n      \"Comments\": \"Inhabits mainstreams of middle reaches in deep rocky rapids.  Juveniles occur in tributaries (Ref. 58784). A large fast-swimming predator, feeding on fish of the middle and the upper water levels.  Although most common along the Thai-Lao border at the mouth of the Mun River, its numbers have drastically decreased in recent years.  This is perhaps due to dam construction or excessive gill netting, to which active pursuit predators, like this species, are particularly vulnerable (Ref. 12693).  Undertakes upstream migration at the same time as <i>Probarbus</i> sp. in December-February (Ref. 37770) which may be related to spawning activity (Ref. 9497).  Attains over 30 kg (Ref. 9497).\",\n      \"Profile\": null,\n      \"PD50\": 1.0,\n      \"Entered\": 113,\n      \"DateEntered\": \"1996-01-12 00:00:00 -0800\",\n      \"Modified\": 1016,\n      \"DateModified\": \"2013-07-24 00:00:00 -0700\",\n      \"Expert\": null,\n      \"DateChecked\": null,\n      \"TS\": null\n    }\n  ]\n}"
  $sealifecountref = {"GrowthCountFresh"=>38, "ABB"=>"AFG"}
  $sealifecountry = {"autoctr"=>851, "Stockcode"=>32, "C_Code"=>"428", "SpecCode"=>24, "CountryRefNo"=>188, "AlsoRef"=>nil, "Status"=>"native", "CurrentPresence"=>"present", "Freshwater"=>0, "Brackish"=>1, "Saltwater"=>0, "Land"=>0, "Comments"=>nil, "Abundance"=>nil, "RefAbundance"=>nil, "Importance"=>"commercial", "RefImportance"=>8984, "ExVesselPrice"=>2454.0215, "Aquaculture"=>nil, "RefAquaculture"=>nil, "LiveExportOrg"=>0, "LiveExport"=>nil, "RefLiveExport"=>nil, "Game"=>0, "Bait"=>0, "Regulations"=>nil, "RefRegulations"=>nil, "Threatened"=>0, "CountrySubComp"=>0, "Entered"=>2, "DateEntered"=>"1993-11-12 00:00:00 +0000", "Modified"=>1, "DateModified"=>"1999-03-22 00:00:00 +0000", "Expert"=>nil, "DateChecked"=>nil, "TS"=>nil}
  $sealifediet = {"DietCode"=>1, "StockCode"=>79, "Speccode"=>69, "DietRefNo"=>9604, "SampleStage"=>"recruits/juv.", "SampleSize"=>37, "YearStart"=>nil, "YearEnd"=>nil, "January"=>0, "February"=>0, "March"=>0, "April"=>-1, "May"=>-1, "June"=>-1, "July"=>0, "August"=>0, "September"=>0, "October"=>0, "November"=>0, "December"=>0, "C_Code"=>"826", "Locality"=>"Off the west coast of the Isle of Man, 1977-1978", "E_Code"=>235, "Method"=>nil, "MethodType"=>nil, "Remark"=>"Length type derived from given length in Species table.", "OtherItems"=>0.1, "PercentEmpty"=>nil, "Troph"=>3.83, "seTroph"=>0.37, "SizeMin"=>30.0, "SizeMax"=>39.0, "SizeType"=>"TL", "FishLength"=>34.5, "Entered"=>34, "DateEntered"=>"1995-07-29 00:00:00 +0000", "Modified"=>nil, "DateModified"=>"2010-12-17 00:00:00 +0000", "Expert"=>nil, "DateChecked"=>nil}
  $sealifeecosystem = {"autoctr"=>1, "E_CODE"=>1, "EcosystemRefno"=>50628, "Speccode"=>549, "Stockcode"=>565, "Status"=>"native", "Abundance"=>nil, "LifeStage"=>"adults", "Remarks"=>nil, "Entered"=>10, "Dateentered"=>"2007-11-12 00:00:00 +0000", "Modified"=>nil, "Datemodified"=>"2007-11-12 00:00:00 +0000", "Expert"=>nil, "Datechecked"=>nil, "WebURL"=>nil, "TS"=>nil}
  $sealifefaoareas = {"autoctr"=>483, "AreaCode"=>1, "SpecCode"=>2, "StockCode"=>1, "Status"=>"endemic", "Entered"=>2, "DateEntered"=>"1990-10-19 00:00:00 +0000", "Modified"=>675, "DateModified"=>"2011-02-11 17:16:45 +0000", "Expert"=>nil, "DateChecked"=>nil, "TS"=>nil}

  def test_route_heartbeat
    res = fetch('heartbeat')
    assert_equal $sealifeheartbeat, res.body
  end

  def test_result_comnames
    res = fetch('comnames')
    assert_equal 10, JSON.parse(res.body)['returned']
  end

  def test_result_by_id
    res = fetch('species/5')
    assert res.ok?
    assert $sealifespecies5, res.body
  end

  def test_result_no_id
    res = fetch('species?limit=1')
    assert res.ok?
    assert $sealifespecies, res.body
  end

  def test_result_countref
    res = fetch('countref')
    assert_equal 10, JSON.parse(res.body)['returned']

    res = fetch('countref?SpecCode=24&fields=GrowthCountFresh,ABB')
    assert_equal $sealifecountref, JSON.parse(res.body)['data'][0]
  end

  def test_result_country
    res = fetch('country')
    assert_equal $sealifecountry, JSON.parse(res.body)['data'][0]
  end

  def test_result_diet
    res = fetch('diet')
    assert_equal $sealifediet, JSON.parse(res.body)['data'][0]
  end

  def test_result_ecology
    res = fetch('ecology')
    assert_equal 4, JSON.parse(res.body).length
  end

  def test_result_ecosystem
    res = fetch('ecosystem')
    assert_equal $sealifeecosystem, JSON.parse(res.body)['data'][0]
  end

  def test_result_faoareas
    res = fetch('faoareas')
    assert_equal $sealifefaoareas, JSON.parse(res.body)['data'][0]
  end

end

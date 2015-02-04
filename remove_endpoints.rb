get '/getfaoareas/?' do
	genus = params[:genus]
	species = params[:species]
	limit = params[:limit] || 10
	query = sprintf("SELECT s.SpecCode, s.Genus, s.Species, k.AreaCode, k.FAO, k.Note, t.status
							FROM species s JOIN faoareas t on s.SpecCode = t.SpecCode
							INNER JOIN faoarref k on t.AreaCode = k.AreaCode
							WHERE Genus = '%s' AND Species = '%s' limit %d", genus, species, limit)
	res = client.query(query, :as => :json)
	out = res.collect{ |row| row }
	err = get_error(out)
	data = { "count" => out.length, "returned" => out.length, "error" => err, "data" => out }
	return JSON.pretty_generate(data)
end

get '/fooditems/?' do
	genus = params[:genus]
	species = params[:species]
	limit = params[:limit] || 10
	query = sprintf("SELECT s.SpecCode, s.Genus, s.Species, t.FoodI, t.FoodII, t.FoodIII, t.PredatorStage
						FROM species s JOIN fooditems t on s.SpecCode = t.SpecCode
						WHERE Genus = '%s' AND Species = '%s' limit %d", genus, species, limit)
	res = client.query(query, :as => :json)
	out = res.collect{ |row| row }
	err = get_error(out)
	data = { "count" => out.length, "returned" => out.length, "error" => err, "data" => out }
	return JSON.pretty_generate(data)
end

def get_count(table, string)
  query = sprintf("SELECT count(*) as ct FROM %s %s", table, string)
  res = $client.query(query, :as => :json)
  res.collect{ |row| row }[0]["ct"]
end

def check_limit_offset(params)
	%i(limit offset).each do |p|
    unless params[p].nil?
      begin
        params[p] = Integer(params[p])
      rescue ArgumentError
        raise Exception.new("#{p.to_s} is not an integer")
      end
    end
  end
  return params
end

def max_limit(params)
	raise Exception.new('limit too large (max 5000)') unless (params[:limit] || 0) <= 5000
end

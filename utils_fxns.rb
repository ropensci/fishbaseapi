# Helper functions for APIs
def list_fields(client, app)
  query = sprintf("SELECT TABLE_NAME,COLUMN_NAME FROM information_schema.`columns` C WHERE TABLE_SCHEMA = '%s'", app)
  res = client.query(query, :as => :json)
  out = res.collect{ |row| row }
  err = get_error(out)
  data = { "count" => out.length, "returned" => out.length, "error" => err, "data" => out }
  return data
end

def read_table(x)
  filename = 'docs/docs-sources/' + x + '.csv'
  if File.exists?(filename)
    dat = File.read(filename)
    csv = CSV.new(dat, :headers => true, :header_converters => :symbol, :converters => :all)
    hash = csv.to_a.map {|row| row.to_hash }
    err = get_error(hash)
    data = { "count" => hash.length, "returned" => hash.length, "error" => err, "data" => hash }
    return JSON.pretty_generate(data)
  else
    halt not_found
  end
end


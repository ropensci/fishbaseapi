$base = "http://fishbase.ropensci.org/"

def fetch(route = '')
  response = HTTParty.get($base + route)
  return response
end

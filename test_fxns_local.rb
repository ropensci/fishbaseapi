$base = "http://localhost:8080/"

def fetch(route = '')
  response = HTTParty.get($base + route)
  return response
end

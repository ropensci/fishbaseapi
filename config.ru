require_relative 'api'

map '/' do
  run API
end

map '/sealifebase' do
  run API
end

require 'minitest/autorun'
require 'rest_client'
require 'json'

class APITest < MiniTest::Test
  # def setup
  #   response = RestClient.get("http://fishbase.ropensci.org/species/5")
  #   @data = JSON.parse response.body
  # end

  # def test_id_correct
  #   p @data
  #   # assert_equal 4, @data['id']
  # end

  def test_route_root
    response = RestClient.get("http://fishbase.ropensci.org/species/5")
    data = JSON.parse response.body
    # p data['returned']
    assert 1, data['returned']
  end
end

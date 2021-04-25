class MapService

  def self.get_geocode(address)
    response = make_api_call("?key=#{ENV['MQ-KEY']}&location=#{address}")
    OpenStruct.new({
                     lat: response[:results].first[:locations].first[:latLng][:lat],
                     lng: response[:results].first[:locations].first[:latLng][:lng]
                    })
  end

  def self.make_api_call(url)
    response = connection.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.connection
    Faraday.new(url: ENV['MQ-GEOCODE-API'])
  end
end

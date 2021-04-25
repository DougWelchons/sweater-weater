class WeatherService

  def self.get_weather(cords)
    response = make_api_call("?lat=#{cords.lat}&lon=#{cords.lng}&exclude=minutely,alerts&appid=80d0fc1196ef1f57628aad517acb93e5&units=imperial")
    current = {
                datetime: response[:current][:dt], #need to make human-readable
                sunrise: response[:current][:sunrise], #need to make human-readable
                sunset: response[:current][:sunset], #need to make human-readable
                temperature: response[:current][:temp],
                feels_like: response[:current][:feels_like],
                humidity: response[:current][:humidity],
                uvi: response[:current][:uvi],
                visibility: response[:current][:visibility],
                conditions: response[:current][:weather].first[:description],
                icon: response[:current][:weather].first[:icon]
               }

    daily = response[:daily].first(5).map do |day|
      {
        date: day[:dt], #need to make human-readable (date only)
        sunrise: day[:sunrise], #need to make human-readable
        sunset: day[:sunset], #need to make human-readable
        max_temp: day[:temp][:max],
        min_temp: day[:temp][:min],
        conditions: day[:weather].first[:description],
        icon: day[:weather].first[:icon]
       }
    end

    hourly = response[:hourly].first(8).map do |hour|
      {
        time: hour[:dt], #need to make human-readable (hour only)
        temperature: hour[:temp],
        conditions: hour[:weather].first[:description],
        icon: hour[:weather].first[:icon]
       }
    end

    OpenStruct.new({id: nil, current_weather: current, daily_weather: daily, hourly_weather: hourly})
  end

  def self.make_api_call(url)
    response = connection.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.connection
    Faraday.new(url: ENV['OW-ONECALL-API'])
  end
end

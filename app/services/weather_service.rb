class WeatherService

  def self.get_weather(cords)
    response = make_api_call("?lat=#{cords.lat}&lon=#{cords.lng}&exclude=minutely,alerts&appid=80d0fc1196ef1f57628aad517acb93e5&units=imperial")
    current = {
                datetime: Time.at(response[:current][:dt]).to_s,
                sunrise: Time.at(response[:current][:sunrise]).to_s,
                sunset: Time.at(response[:current][:sunset]).to_s,
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
        date: Time.at(day[:dt]).strftime('%Y-%m-%d'),
        sunrise: Time.at(day[:sunrise]).to_s,
        sunset: Time.at(day[:sunset]).to_s,
        max_temp: day[:temp][:max],
        min_temp: day[:temp][:min],
        conditions: day[:weather].first[:description],
        icon: day[:weather].first[:icon]
       }
    end

    hourly = response[:hourly].first(8).map do |hour|
      {
        time: Time.at(hour[:dt]).strftime('%H:%M:%S'),
        temperature: hour[:temp],
        conditions: hour[:weather].first[:description],
        icon: hour[:weather].first[:icon]
       }
    end

    OpenStruct.new({id: nil, current_weather: current, daily_weather: daily, hourly_weather: hourly})
  end

  def self.get_current_weather(cords)
    response = make_api_call("?lat=#{cords.lat}&lon=#{cords.lng}&exclude=minutely,alerts&appid=80d0fc1196ef1f57628aad517acb93e5&units=imperial")

    OpenStruct.new({summary: response[:current][:weather].first[:description], temperature: "#{response[:current][:temp]} F"})
  end

  def self.make_api_call(url)
    response = connection.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.connection
    Faraday.new(url: ENV['OW-ONECALL-API'])
  end
end

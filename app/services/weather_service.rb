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
    # Faraday.new(url: ENV['MQ-GEOCODE-API'], params: { api_key: ENV['MQ-KEY'] })
  end
end


# current
# => {:dt=>1619235581,
# :sunrise=>1619181369,
# :sunset=>1619232266,
# :temp=>50,
# :feels_like=>49.3,
# # :pressure=>1008,
# :humidity=>50,
# # :dew_point=>32.11,
# :uvi=>0,
# # :clouds=>90,
# :visibility=>10000,
# # :wind_speed=>3.44,
# # :wind_deg=>100,
# :weather=>[{(:id=>804,) (:main=>"Clouds"), :description=>"overcast clouds", :icon=>"04n"}]}
#
#
# daily
# {:dt=>1619204400,
#   :sunrise=>1619181369,
#   :sunset=>1619232266,
#   # :moonrise=>1619216520,
#   # :moonset=>1619177580,
#   # :moon_phase=>0.37,
#   :temp=>{(:day=>45.59,) :min=>31.24, :max=>50.52, (:night=>48.24, :eve=>50.13, :morn=>32.52)},
#   # :feels_like=>{:day=>45.59, :night=>32.52, :eve=>47.46, :morn=>32.52},
#   # :pressure=>1016,
#   # :humidity=>64,
#   # :dew_point=>29.64,
#   # :wind_speed=>3.18,
#   # :wind_deg=>78,
#   # :wind_gust=>4.09,
#   :weather=>[{(:id=>804, :main=>"Clouds"), :description=>"overcast clouds", :icon=>"04d"}],
#   # :clouds=>100,
#   # :pop=>0.23,
#   # :uvi=>3.27},
#
#
# hour
# :dt=>1619233200,
#     :temp=>48.4,
#     # :feels_like=>48.4,
#     # :pressure=>1009,
#     # :humidity=>57,
#     # :dew_point=>33.89,
#     # :uvi=>0,
#     # :clouds=>90,
#     # :visibility=>10000,
#     # :wind_speed=>2.71,
#     # :wind_deg=>97,
#     # :wind_gust=>2.46,
#     :weather=>[{(:id=>804, :main=>"Clouds"), :description=>"overcast clouds", :icon=>"04n"}],
#     # :pop=>0},

class RoadTripFacade
  extend Validatable

  def self.get_route(params)
    return OpenStruct.new({errors: "Unautherized user"}) unless User.find_by(api_key: params[:api_key])
    errors = validate_required_param(params, [:origin, :destination])
    if errors.any?
      OpenStruct.new({errors: errors})
    else
      route = MapService.get_route(params[:origin], params[:destination])
      if route.travel_time == "impossible"
        OpenStruct.new({id: nil, start_city: params[:origin], end_city: params[:destination], travel_time: route.travel_time, weather_at_eta: {}})
      else
        Rails.cache.fetch("get-cords-#{params[:destination]}", expires_in: 1.minute) do
          @cords = MapService.get_geocode(params[:destination])
        end
        weather = WeatherService.get_future_weather(@cords, route.offset)
        OpenStruct.new({id: nil, start_city: params[:origin], end_city: params[:destination], travel_time: route.travel_time, weather_at_eta: {temperature: weather.temperature, conditions: weather.summary}})
      end
    end
  end
end

class Api::V1::RoadTripController < ApplicationController

  def create
    return error("Origin required") unless params[:origin]
    return error("Origin cannot be blank") if params[:origin] == ''
    return error("Destination required") unless params[:destination]
    return error("Destination cannot be blank") if params[:destination] == ''
    return error("API Key required") unless params[:api_key]
    return error("API Key cannot be blank") if params[:api_key] == ''
    return error("Unautherized user") unless User.find_by(api_key: params[:api_key])
    route = MapService.get_route(params[:origin], params[:destination])
    if route.travel_time == "impossible"
      trip = OpenStruct.new({id: nil, start_city: params[:origin], end_city: params[:destination], travel_time: route.travel_time, weather_at_eta: {}})
    else
      cords = MapService.get_geocode(params[:destination])
      weather = WeatherService.get_future_weather(cords, route.offset)
      trip = OpenStruct.new({id: nil, start_city: params[:origin], end_city: params[:destination], travel_time: route.travel_time, weather_at_eta: {temperature: weather.temperature, conditions: weather.summary}})
    end
    render json: RoadtripSerializer.new(trip)
  end
end

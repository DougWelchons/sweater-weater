class Api::V1::ForecastController < ApplicationController

  def index
    return error("Location required") unless params[:location]
    return error("location cannot be blank") if params[:location] == ''
    cords = MapService.get_geocode(params[:location])
    weather = WeatherService.get_weather(cords)
    render json: ForecastSerializer.new(weather)
  end
end

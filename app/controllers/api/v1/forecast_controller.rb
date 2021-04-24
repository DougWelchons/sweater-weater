class Api::V1::ForecastController < ApplicationController

  def index
    cords = MapService.get_geocode(params[:location])
    weather = WeatherService.get_weather(cords)
    render json: ForecastSerializer.new(weather)
  end
end

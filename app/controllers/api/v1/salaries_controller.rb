class Api::V1::SalariesController < ApplicationController
  def index
    cords = MapService.get_geocode(params[:destination])
    weather = WeatherService.get_current_weather(cords)
    salaries = SalariesService.get_salaries(params[:destination])
  end
end

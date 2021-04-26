class Api::V1::SalariesController < ApplicationController

  def index
    cords = MapService.get_geocode(params[:destination])
    weather = WeatherService.get_current_weather(cords)
    salaries = SalariesService.get_salaries(params[:destination])
    jobs = OpenStruct.new({id: nil, destination: params[:destination], forecast: {summary: weather.summary, temperature: weather.temperature}, salaries: salaries.salaries})
    render json: SalariesSerializer.new(jobs)
  end
end

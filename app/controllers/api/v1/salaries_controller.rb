class Api::V1::SalariesController < ApplicationController

  def index
    return error("Destination required") unless params[:destination]
    return error("Destination cannot be blank") if params[:destination] == ''
    # cords = MapService.get_geocode(params[:destination])
    # weather = WeatherService.get_current_weather(cords)
    # salaries = SalariesService.get_salaries(params[:destination])
    # jobs = OpenStruct.new({id: nil, destination: params[:destination], forecast: {summary: weather.summary, temperature: weather.temperature}, salaries: salaries.salaries})
    jobs = SalariesFacade.get_salaries(params[:destination])
    render json: SalariesSerializer.new(jobs)
  end
end

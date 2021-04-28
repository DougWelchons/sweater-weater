class Api::V1::ForecastController < ApplicationController

  def index
    weather = ForecastFacade.get_forecast(params)

    if weather.errors
      render json: error(weather.errors), status: :bad_request
    else
      render json: ForecastSerializer.new(weather)
    end
  end
end

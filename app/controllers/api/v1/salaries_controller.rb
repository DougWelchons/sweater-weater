class Api::V1::SalariesController < ApplicationController

  def index
    return error("Destination required") unless params[:destination]
    return error("Destination cannot be blank") if params[:destination] == ''
    jobs = SalariesFacade.get_salaries(params[:destination])
    return error(jobs.error) if jobs.error
    render json: SalariesSerializer.new(jobs)
  end
end

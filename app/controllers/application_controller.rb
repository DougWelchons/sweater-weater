class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record
  

  def error(message = "Request error, please check you request and try again")
    link = "https://github.com/DougWelchons/sweater-weater#endpoint-documentation"
    render json: {error: [message, link]}, status: :bad_request
  end

  def render_invalid_record(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end

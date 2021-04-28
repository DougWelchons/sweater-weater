class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record


  def error(message = "Error, please check you request and try again")
    link = "https://github.com/DougWelchons/sweater-weather#endpoint-documentation"
    {error: [message, link].flatten}
  end

  def render_invalid_record(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end

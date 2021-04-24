class ApplicationController < ActionController::API

  def error(message = "Request error, please check you request and try again")
    link = "https://github.com/DougWelchons/sweater-weater#endpoint-documentation"
    render json: {error: [message, link]}, status: :bad_request
  end
end

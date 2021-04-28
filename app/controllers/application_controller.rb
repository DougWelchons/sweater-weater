class ApplicationController < ActionController::API

  def error(message = "Error, please check you request and try again")
    link = "https://github.com/DougWelchons/sweater-weather#endpoint-documentation"
    {error: [message, link].flatten}
  end
end

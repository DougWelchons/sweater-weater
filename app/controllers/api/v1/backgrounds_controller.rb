class Api::V1::BackgroundsController < ApplicationController


  def index
    image = BackgroundsFacade.get_background(params)

    if image.errors
      render json: error(image.errors), status: :bad_request
    else
      render json: ImageSerializer.new(image)
    end
  end
end

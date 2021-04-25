class Api::V1::BackgroundsController < ApplicationController


  def index
    image = ImageService.get_image(params[:location])

    render json: ImageSerializer.new(image)
  end
end

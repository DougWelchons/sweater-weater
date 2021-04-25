class Api::V1::BackgroundsController < ApplicationController


  def index
    return error("Location required") unless params[:location]
    return error("location cannot be blank") if params[:location] == ''
    image = ImageService.get_image(params[:location])
    render json: ImageSerializer.new(image)
  end
end

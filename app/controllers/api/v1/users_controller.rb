class Api::V1::UsersController < ApplicationController

  def create
    user = User.new(user_params)
    api_key = SecureRandom.hex(20)
    user.api_key = api_key
    user.save!
    render json: UsersSerializer.new(user), status: :created
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end

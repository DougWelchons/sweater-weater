class Api::V1::UsersController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record

  def create
    user = User.new(user_params)
    user.api_key = SecureRandom.hex(20)
    user.save!
    render json: UsersSerializer.new(user), status: :created
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

  def render_invalid_record(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end

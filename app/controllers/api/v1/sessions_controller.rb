class Api::V1::SessionsController < ApplicationController

  def create
    return login_error unless params[:email]
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      render json: UsersSerializer.new(user)
    else
      login_error
    end
  end

  def login_error
    render json: {error: "Invalid Login"}, status: :bad_request
  end
end

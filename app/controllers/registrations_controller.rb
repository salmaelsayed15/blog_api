class RegistrationsController < ApplicationController
  skip_before_action :authenticate_request, only: :create

  def create
    if User.exists?(email: user_params[:email])
      render json: { errors: [ "Email already exists. Please use a different email." ] }, status: :unprocessable_entity
    else
      user = User.new(user_params)
      if user.save
        token = JsonWebToken.encode(user_id: user.id)
        render json: { token: token, user: user }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :image)
  end
end

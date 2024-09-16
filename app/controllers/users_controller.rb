class UsersController < ApplicationController
  # # No need to skip CSRF as it's not defined for ActionController::API
  # Skip_before_action :verify_authenticity_token

  # Skip authentication for the user registration action
  skip_before_action :authenticate_request, only: :create

  def create
    user = User.new(user_params)
    if user.save
      render json: { status: "success", user: user }, status: :created
    else
      Rails.logger.error("User creation failed: #{user.errors.full_messages.join(', ')}")
      render json: { status: "error", errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :image)
  end
end

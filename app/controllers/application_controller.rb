class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    token = request.headers["Authorization"]&.split(" ")&.last
    if token
      begin
        decoded_token = JsonWebToken.decode(token)
        @current_user = User.find(decoded_token[:user_id])
      rescue JWT::DecodeError => e
        Rails.logger.error("JWT Decode Error: #{e.message}")
        render json: { errors: "Invalid token" }, status: :unauthorized
      rescue ActiveRecord::RecordNotFound => e
        Rails.logger.error("User not found: #{e.message}")
        render json: { errors: "User not found" }, status: :unauthorized
      rescue StandardError => e
        Rails.logger.error("Authentication error: #{e.message}")
        render json: { errors: "Unauthorized" }, status: :unauthorized
      end
    else
      render json: { errors: "Token missing" }, status: :unauthorized
    end
  end
end

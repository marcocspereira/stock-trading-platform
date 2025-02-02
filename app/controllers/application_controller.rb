class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  rescue_from ::ForbiddenActionError, with: :forbidden_action
  rescue_from ::BusinessNotAvailableError, with: :business_not_available
  rescue_from ::InvalidQuantityError, with: :invalid_quantity
  rescue_from ::InvalidBuyOrderStatusError, with: :invalid_buy_order_status
  rescue_from ::InvalidBuyOrderError, with: :invalid_buy_order

  # Global authentication before any action in the application
  before_action :authenticate_user

  attr_reader :current_user

  private

   # Custom basic authentication method
   def authenticate_user
    authenticate_or_request_with_http_basic do |username, password|
      @current_user = User.find_by(username: username)&.authenticate(password)
    end
  end

  def forbidden_action(e)
    render json: { error: e.message || message }, status: :forbidden
  end

  def business_not_available(e)
    render json: { error: e.message || message }, status: :unprocessable_entity
  end

  def invalid_quantity(e)
    render json: { error: e.message || message }, status: :unprocessable_entity
  end

  def invalid_buy_order_status(e)
    render json: { error: e.message || message }, status: :unprocessable_entity
  end

  def invalid_buy_order(e)
    render json: { error: e.message || message }, status: :unprocessable_entity
  end
end

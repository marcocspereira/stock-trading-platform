class Api::V1::BuyOrdersController < ApplicationController
  # GET /api/v1/businesses/:business_id/buy_orders
  # Index all buy orders for a business, only available for owners
  def index
    buy_orders = BuyOrders::Fetcher.call(params, current_user)

    render json: buy_orders, each_serializer: BuyOrderSerializer
  end

  # GET /api/v1/buy_orders/:id
  # Show a buy order, only available for owners and buyers
  def show
    buy_order = BuyOrder.includes(:business).find(params[:id])

    unless buy_order.buyer_id == current_user.id || buy_order.business.owner_id == current_user.id
      render json: { error: "Forbidden access" }, status: :forbidden and return
    end

    render json: buy_order, serializer: BuyOrderSerializer
  end

  # POST /api/v1/businesses/:business_id/buy_orders
  # Create a new buy order for a business, only available for buyers
  def create
    raise InvalidBuyOrderError, "Invalid parameters" if buy_order_params.blank?

    buy_order = BuyOrders::Creator.new(current_user, params[:business_id], buy_order_params).call
    if buy_order.persisted?
      render json: buy_order, status: :created
    else
      render json: buy_order.errors, status: :unprocessable_entity
    end
  end

  # PATCH /api/v1/businesses/:business_id/buy_orders/:id
  # Update a buy order status, only available for owners
  def update
    buy_order = BuyOrder.includes(:business).find(params[:id])

    buy_order_params_to_update = params.require(:buy_order).permit(:quantity, :price, :status)
    updater = BuyOrders::UpdaterService.build(buy_order, current_user)
    updated_order = updater.call(buy_order_params_to_update)

    if updated_order
      render json: updated_order, serializer: BuyOrderSerializer, status: :ok
    else
      render json: { error: updater.errors.join(", ") }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/businesses/:business_id/buy_orders/:id
  # Delete a buy order, only available for buyers and if the order is pending
  def destroy
    BuyOrders::Destroyer.new(params[:id], current_user).call

    head :no_content
  end

  private

  def buy_order_params
    params.require(:buy_order).permit(:quantity, :price, :business_id)
  rescue ActionController::ParameterMissing
    {}
  end
end

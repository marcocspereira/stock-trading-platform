module BuyOrders
  class Destroyer
    def initialize(buy_order_id, current_user)
      @buy_order = BuyOrder.find(buy_order_id)
      @current_user = current_user
    end

    def call
      raise InvalidBuyOrderError unless is_buyer?
      raise InvalidBuyOrderError unless @buy_order.pending?

      @buy_order.destroy!
    end

    private

    def is_buyer?
      @current_user.id == @buy_order.buyer_id
    end
  end
end

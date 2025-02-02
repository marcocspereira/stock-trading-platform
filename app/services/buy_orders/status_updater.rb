module BuyOrders
  class StatusUpdater < BaseUpdater
    def call(params)
      validate_pending!
      validate_owner!

      action_to_call = BuyOrder::VALID_ACTIONS.fetch(params[:status]) do
        raise InvalidBuyOrderStatusError, "Invalid params/status for business owner"
      end

      ActiveRecord::Base.transaction do
        send(action_to_call)
      end

      @buy_order
    rescue StandardError => e
      @errors << e.message
      false
    end

    private

    def accept
      business = lock_business(@buy_order.business_id)
      lock_buy_order(@buy_order)

      validate_available_shares!(business)

      @buy_order.approve!
      business.update!(available_shares: business.available_shares - @buy_order.quantity)

      create_transaction(business)
    end

    def reject
      lock_buy_order(@buy_order)
      @buy_order.reject!
    end

    def lock_business(business_id)
      Business.lock("FOR UPDATE").find(business_id)
    end

    def lock_buy_order(buy_order)
      buy_order.lock!
    end

    def validate_available_shares!(business)
      raise InsufficientSharesError, "Not enough available shares" if business.available_shares < @buy_order.quantity
    end

    def create_transaction(business)
      Transaction.create!(business: business, quantity: @buy_order.quantity, price: @buy_order.price, user_id: @buy_order.buyer_id)
    end
  end
end

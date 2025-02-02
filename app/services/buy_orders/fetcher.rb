module BuyOrders
  class Fetcher
    def self.call(params, current_user)
      if params[:business_id]
        fetch_business_buy_orders(params[:business_id], current_user)
      else
        fetch_user_buy_orders(current_user)
      end
    end

    private

    # Fetch all buy orders for a business, only available for owners
    def self.fetch_business_buy_orders(business_id, current_user)
      Business.find_by(id: business_id, owner: current_user).buy_orders
    end

    # Fetch all buy orders for a user, available for all users
    def self.fetch_user_buy_orders(current_user)
      BuyOrder.where(buyer: current_user)
    end
  end
end

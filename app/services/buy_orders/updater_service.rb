module BuyOrders
  class UpdaterService
    def self.build(buy_order, current_user)
      if buy_order.business.owner_id == current_user.id
        StatusUpdater.new(buy_order, current_user)
      elsif buy_order.buyer_id == current_user.id
        ValueUpdater.new(buy_order, current_user)
      else
        raise ForbiddenActionError, "User not authorized to update this buy order"
      end
    end
  end
end

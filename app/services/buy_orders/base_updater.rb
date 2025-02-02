module BuyOrders
  class BaseUpdater
    attr_reader :buy_order, :errors

    def initialize(buy_order, user)
      @buy_order = buy_order
      @user = user

      @errors = []
    end

    def call(params)
      raise NotImplementedError, "Subclass #{self.class.name} must implement #call"
    end

    private

    def validate_pending!
      raise InvalidBuyOrderError, "Buy order must be pending" unless @buy_order.pending?
    end

    def validate_owner!
      raise ForbiddenActionError, "Only the owner can update status" unless @buy_order.business.owner_id == @user.id
    end

    def validate_buyer!
      raise ForbiddenActionError, "Only the buyer can update values" unless @buy_order.buyer_id == @user.id
    end
  end
end

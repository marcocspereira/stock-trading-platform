module BuyOrders
  class Creator
    def initialize(current_user, business_id, params)
      @business = Business.find(business_id)
      raise ActiveRecord::RecordNotFound, "Couldn't find Business with 'id'=#{business_id}" if @business.nil?

      @user = current_user
      @quantity = params[:quantity].to_i
      @price = params[:price].to_d
    end

    def call
      raise InvalidBuyOrderError, "Invalid parameters" unless valid_params?
      raise InvalidBuyOrderError, "You are the owner of this business and cannot buy shares" if is_owner?
      raise BusinessNotAvailableError, "Business is not available" unless @business.is_available?
      raise InvalidQuantityError, "Invalid quantity" unless is_valid_quantity?

      buy_order = BuyOrder.create(business_id: @business.id, buyer_id: @user.id, quantity: @quantity, price: @price)
      buy_order
    end

    private

    def valid_params?
      @business && @user && @quantity && @price
    end

    def is_owner?
      @user.id == @business.owner_id
    end

    def is_valid_quantity?
      @quantity > 0 && @quantity <= @business.remaining_shares
    end
  end
end

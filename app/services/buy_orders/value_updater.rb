module BuyOrders
  class ValueUpdater < BaseUpdater
    def call(params)
      validate_pending!
      validate_buyer!

      ActiveRecord::Base.transaction do
        lock_buy_order(@buy_order)
        update_buy_order(params)
      end

      @buy_order
    rescue StandardError => e
      false
    end

    private

    def lock_buy_order(buy_order)
      buy_order.lock!
    end

    def update_buy_order(params)
      updates = {}
      updates[:price] = params[:price].to_d if valid_number?(params[:price])
      updates[:quantity] = params[:quantity].to_i if valid_number?(params[:quantity])

      unless updates.any?
        @errors << "Invalid input(s), check: #{(params.keys-updates.keys).join(', ')}"
        raise UpdateFailedError, "Invalid input(s), check: #{(params.keys-updates.keys).join(', ')}"
      end

      @buy_order.update!(updates)
      @buy_order
    end

    def valid_number?(number)
      number.present? && number.to_s.match?(/\A\d+(\.\d+)?\z/)
    end
  end
end

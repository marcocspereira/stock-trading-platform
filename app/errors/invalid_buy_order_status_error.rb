class InvalidBuyOrderStatusError < StandardError
  def initialize(msg = "Invalid buy order status")
    super(msg)
  end
end

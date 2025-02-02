class InvalidBuyOrderError < StandardError
  def initialize(msg = "Invalid buy order")
    super(msg)
  end
end

class InsufficientSharesError < StandardError
  def initialize(msg = "Not enough available shares")
    super(msg)
  end
end

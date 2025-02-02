class BusinessNotAvailableError < StandardError
  def initialize(msg = "Business not available")
    super(msg)
  end
end

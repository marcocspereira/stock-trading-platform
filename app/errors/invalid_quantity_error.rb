class InvalidQuantityError < StandardError
  def initialize(msg = "Invalid quantitys")
    super(msg)
  end
end

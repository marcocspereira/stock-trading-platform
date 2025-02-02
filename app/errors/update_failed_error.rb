class UpdateFailedError < StandardError
  def initialize(msg = "Failed to update resource")
    super(msg)
  end
end

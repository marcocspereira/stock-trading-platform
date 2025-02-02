class ForbiddenActionError < StandardError
  def initialize(msg = "Forbidden action")
    super(msg)
  end
end

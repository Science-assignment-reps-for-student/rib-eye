class ExceptionCore < StandardError

  def initialize(message)
    super(message)
  end

  def self.except(error)
    raise error if error.should_raise

    error
  end
end
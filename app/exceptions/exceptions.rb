module Exceptions
  include NotFoundException

  def self.except(exception, params)
    error = exception.new(params)

    raise error if error.should_raise
  end
end

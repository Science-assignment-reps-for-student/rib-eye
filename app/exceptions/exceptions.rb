# frozen_string_literal: true

Dir.glob(File.expand_path('./app/exceptions/*', __dir__)).sort.each { |f| require f }

module Exceptions
  include UnauthorizedException
  include ForbiddenException
  include NotFoundException

  def self.except(exception, params)
    error = exception.new(params)

    raise error if error.should_raise

    error
  end

  def render_error(error)
    render json: { error_message: error.message },
           status: error.status
  end
end

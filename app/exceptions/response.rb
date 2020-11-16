# frozen_string_literal: true

Dir.glob(File.expand_path('response/*', __dir__)).sort.each { |f| require_relative f }

module Response
  include BadRequestException
  include UnauthorizedException
  include ForbiddenException
  include NotFoundException
  include ConflictException
  include UnsupportedMediaTypeException

  def render_error(error)
    render json: { error_message: error.message },
           status: error.status
  end
end

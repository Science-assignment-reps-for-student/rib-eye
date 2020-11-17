# frozen_string_literal: true

Dir.glob(File.expand_path('response/*', __dir__)).sort.each { |f| require_relative f }

module Response
  include BadRequestException
  include UnauthorizedException
  include ForbiddenException
  include NotFoundException
  include ConflictException
  include UnsupportedMediaTypeException
end

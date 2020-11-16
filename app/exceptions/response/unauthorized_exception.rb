# frozen_string_literal: true

require './app/exceptions/exception_core'

module UnauthorizedException
  class Unauthorized < ExceptionCore
    attr_reader :should_raise, :status, :jwt

    def initialize(authorization)
      @status = :unauthorized

      authorization = authorization&.split(' ').to_a
      @jwt = authorization[1] if authorization[0] == 'Bearer'
      @should_raise = @jwt.nil?

      super('Unauthorized : undefined token')
    end

    def self.except(authorization)
      super(new(authorization))
    end
  end
end
# frozen_string_literal: true

module UnauthorizedException
  class Unauthorized < StandardError
    attr_reader :should_raise, :status, :jwt

    def initialize(authorization)
      @status = :unauthorized
      @should_raise = false

      authorization = authorization&.split(' ')
      raise self if authorization.nil?

      @jwt = authorization[1] if authorization[0] == 'Bearer'
      @should_raise = true if @jwt.nil?

      super('Unauthorized : undefined token')
    end
  end
end
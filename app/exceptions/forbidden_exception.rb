# frozen_string_literal: true

require 'jwt_base'
require './app/exceptions/unauthorized_exception'

module ForbiddenException
  class Forbidden < StandardError
    attr_reader :should_raise, :status, :payload

    JWT_BASE = JWTBase.new(ENV['SECRET_KEY_BASE'], 1.days, 2.weeks)

    def initialize(authorization)
      @status = :forbidden

      @payload = JWT_BASE.jwt_required(UnauthorizedException::Unauthorized.new(authorization).jwt)
      @should_raise = @payload.blank?

      super('Forbidden : invalid token')
    end
  end

  def admin?
    raise ForbiddenException::Forbidden unless Admin.find_by_email(@payload['sub'])
  end

  def student?
    raise ForbiddenException::Forbidden unless Student.find_by_email(@payload['sub'])
  end
end
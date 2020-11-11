require 'jwt_base'

class ApplicationController < ActionController::API
  include Exceptions

  rescue_from 'UnauthorizedException::Unauthorized' do |e| render_error(e) end
  rescue_from 'ForbiddenException::Forbidden' do |e| render_error(e) end
  rescue_from 'NotFoundException::NotFound' do |e| render_error(e) end

  before_action do
    @payload = Exceptions.except(ForbiddenException::Forbidden, request.authorization).payload
  end
end

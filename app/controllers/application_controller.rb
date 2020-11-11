require 'jwt_base'

class ApplicationController < ActionController::API
  include Exceptions

  rescue_from 'NotFoundException::NotFound' do |e| not_found(e) end

  @@jwt_base = JWTBase.new(ENV['SECRET_KEY_BASE'], 1.days, 2.weeks)

  def jwt_required
    return render status: :unauthorized unless token

    @payload = @@jwt_base.jwt_required(token)
    return render status: @payload[:status] if @payload[:status]

    @payload
  end

  def token
    return nil unless request.authorization

    authorization = request.authorization.split(' ')
    authorization[1] if authorization[0] == 'Bearer'
  end
end

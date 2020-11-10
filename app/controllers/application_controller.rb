require 'jwt_base'

class ApplicationController < ActionController::API
  @@jwt_base = JWTBase.new(ENV['SECRET_KEY_BASE'], 1.days, 2.weeks)

  def jwt_required
    return render status: :unauthorized unless token

    @payload = @@jwt_base.jwt_required(token)
    return render status: @payload[:status] if @payload[:status]

    @payload
  end

  def token
    return false unless request.authorization

    authorization = request.authorization.split(' ')
    if authorization[0] == 'Bearer'
      authorization[1]
    end
  end
end

require 'jwt_base'

class ApplicationController < ActionController::API
  @@jwt_base = JWTBase.new(ENV['SECRET_KEY_BASE'], 1.days, 2.weeks)

  def current_student
    Student.find_by_email(@payload['sub'])
  end

  def current_admin
    Admin.find_by_email(@payload['sub'])
  end

  def jwt_required
    return render status: :forbidden unless token

    @payload = @@jwt_base.jwt_required(token)
    return render status: @payload[:status] if @payload[:status]

    @payload
  end

  def refresh_token_required
    return render status: :forbidden unless token

    @payload = @@jwt_base.refresh_token_required(token)
    return render status: @payload[:status] if @payload[:status]

    @payload
  end

  def token
    return false unless request.authorization

    authorization = request.authorization.split(' ')
    if authorization[0] == 'Bearer'
      authorization[1]
    else
      false
    end
  end
end

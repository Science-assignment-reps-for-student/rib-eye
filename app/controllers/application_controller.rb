require 'jwt_base'

class ApplicationController < ActionController::API
  @@jwt_base = JWTBase.new(ENV['SECRET_KEY_BASE'], 1.days, 2.weeks)

  def current_team
    current_student
    @team = Team.find_by_leader_id(@student.id)
    render status: :forbidden unless @team
  end

  def current_student
    @student = Student.find_by_email(@payload['sub'])
    return render status: :forbidden unless @student
  end

  def current_admin
    @admin = Admin.find_by_email(@payload['sub'])
    return render status: :forbidden unless @admin
  end

  def current_assignment
    @assignment = Assignment.find_by_id(params[:assignment_id])
    return render status: :not_found unless @assignment
  end

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

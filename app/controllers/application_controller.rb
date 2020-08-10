require 'jwt_base'

class ApplicationController < ActionController::API
  @@jwt_base = JWTBase.new(ENV['SECRET_KEY_BASE'], 1.days, 2.weeks)

  def file_input_stream
    params.require(:file)

    @files = params[:file].map do |file|
      unless ApplicationRecord::EXTNAME_WHITELIST.include?(File.extname(file).downcase)
        return render status: :unsupported_media_type
      end

      File.open(file)
    end
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

  def refresh_token_required
    return render status: :unauthorized unless token

    @payload = @@jwt_base.refresh_token_required(token)
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

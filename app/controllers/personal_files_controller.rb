require './app/services/personal_file_service'

class PersonalFilesController < ApplicationController
  include PersonalFileService

  before_action :file_filter, only: %i[create]

  before_action :admin?, only: %i[show status_for_admin]
  before_action :student?, except: %i[show status_for_admin]

  def show
    params.require(%i[file_id])

    super(model: PersonalFile, file_id: params[:file_id])
  end

  def status_for_admin
    params.require(%i[student_id assignment_id])

    render json: index(model: PersonalFile,
                       student_id: params[:student_id],
                       assignment_id: params[:assignment_id]),
           status: :ok
  end

  def status_for_student
    params.require(%i[assignment_id])

    render json: index(model: PersonalFile,
                       student_email: @payload['sub'],
                       assignment_id: params[:assignment_id]),
           status: :ok
  end

  def create
    params.require(%i[assignment_id])

    super(model: PersonalFile,
          files: @files,
          student_email: @payload['sub'],
          assignment_id: params[:assignment_id],
          created_at: Time.zone.now)

    render status: :created
  end

  def destroy
    params.require(%i[file_id])

    super(model: PersonalFile, file_id: params[:file_id])

    render status: :ok
  end
end

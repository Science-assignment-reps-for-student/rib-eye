require './app/services/personal_file_service'

class PersonalFilesController < ApplicationController
  include FileScaffold::HelperMethod
  include PersonalFileService

  before_action :jwt_required
  before_action :file_input_stream, only: :create
  before_action :current_assignment, only: %i[create status_for_admin status_for_student]
  before_action :current_student, only: %i[create destroy status_for_student]
  before_action :current_admin, only: %i[show status_for_admin]

  def show
    params.require(%i[file_id])

    file = PersonalFile.find_by_id(params[:file_id])

    send_file(file.path,
              filename: file.file_name)
  end

  def status_for_admin
    params.require(%i[student_id assignment_id])

    render json: { file_information: index(model: PersonalFile,
                                           student_id: params[:student_id],
                                           assignment_id: params[:assignment_id]) },
           status: :ok
  end

  def status_for_student
    params.require(%i[assignment_id])

    render json: { file_information: index(model: PersonalFile,
                                           student_id: @student.id,
                                           assignment_id: params[:assignment_id]) },
           status: :ok
  end

  def create
    params.require(%i[assignment_id])

    super(model: PersonalFile,
          files: @files,
          student_id: @payload['sub'],
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

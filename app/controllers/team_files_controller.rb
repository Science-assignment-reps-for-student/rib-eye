require './app/services/team_file_service'

class TeamFilesController < ApplicationController
  include TeamFileService

  before_action :file_filter, only: %i[create]

  before_action :admin?, only: %i[show status_for_admin]
  before_action :student?, except: %i[show status_for_admin]

  def show
    params.require(%i[file_id])

    super(file_id: params[:file_id])
  end

  def status_for_admin
    params.require(%i[team_id assignment_id])

    render json: index(team_id: params[:team_id],
                       assignment_id: params[:assignment_id]),
           status: :ok
  end

  def status_for_student
    params.require(%i[assignment_id])

    render json: index(student_email: @payload['sub'],
                       assignment_id: params[:assignment_id]),
           status: :ok
  end

  def create
    params.require(%i[assignment_id])

    super(files: @files,
          student_email: @payload['sub'],
          assignment_id: params[:assignment_id])

    render status: :created
  end

  def destroy
    params.permit(%i[file_id])

    super(file_id: params[:file_id])

    render status: :ok
  end
end

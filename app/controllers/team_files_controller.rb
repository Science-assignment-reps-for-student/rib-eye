require './app/services/team_file_service'

class TeamFilesController < ApplicationController
  include FileScaffold::HelperMethod
  include TeamFileService

  before_action :jwt_required
  before_action :file_input_stream, only: :create
  before_action :current_assignment, only: %i[create status_for_admin status_for_student]
  before_action :current_team, only: %i[create destroy status_for_student]
  before_action :current_admin, only: %i[show status_for_admin]

  def show
    params.permit(%i[file_id])
    file = TeamFile.find_by_id(params[:file_id])
    send_file(file.path,
              filename: file.file_name)
  end

  def status_for_admin
    params.permit(%i[team_id assignment_id])
    render json: { file_information: index(team_id: params[:team_id],
                                           assignment_id: params[:assignment_id])},
           status: :ok
  end

  def status_for_student
    params.permit(%i[assignment_id])
    render json: { file_information: index(team_id: @student.team(params[:assignment_id]).id,
                                           assignment_id: params[:assignment_id]) },
           status: :ok
  end

  def create
    params.permit(%i[assignment_id])
    super(files: @files,
          team_id: @student.team(params[:assignment_id]).id,
          assignment_id: params[:assignment_id])
    render status: :created
  end

  def destroy
    params.permit(%i[file_id])
    super(file_id: params[:file_id])
    render status: :ok
  end
end

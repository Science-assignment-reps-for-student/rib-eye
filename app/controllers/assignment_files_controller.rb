require './app/services/assignment_file_service'

class AssignmentFilesController < ApplicationController
  include AssignmentFileService

  before_action :jwt_required
  before_action :current_assignment, only: :index
  before_action :current_admin, only: :destroy

  def show
    params.require(%i[file_id])

    file = AssignmentFile.find_by_id(params[:file_id])

    send_file(file.path,
              filename: file.file_name)
  end

  def index
    params.require(%i[assignment_id])

    render json: super(assignment_id: params[:assignment_id]),
           status: :ok
  end

  def destroy
    params.require(%i[file_id])

    super(file_id: params[:file_id])

    render status: :ok
  end
end

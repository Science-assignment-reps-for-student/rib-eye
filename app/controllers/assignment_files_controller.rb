require './app/services/assignment_file_service'

class AssignmentFilesController < ApplicationController
  include AssignmentFileService

  before_action :admin?, only: %i[destroy]

  def show
    params.require(%i[file_id])

    super(file_id: params[:file_id])
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

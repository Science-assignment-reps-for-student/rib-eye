class AssignmentFilesController < ApplicationController
  include FileScaffold::ControllerMethod

  before_action :jwt_required
  before_action :current_assignment, only: :index
  before_action :current_admin, only: :destroy

  def show
    params.require(:file_id)

    super { AssignmentFile.find_by_id(params[:file_id]) }
  end

  def index
    file_information = @assignment.assignment_files.map do |file|
      {
        file_name: file.file_name,
        file_id: file.id
      }
    end

    render json: file_information
  end

  def destroy
    super(AssignmentFile)
  end
end

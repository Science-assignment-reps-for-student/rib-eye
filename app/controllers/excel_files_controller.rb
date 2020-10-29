require './app/services/excel_file_service'

class ExcelFilesController < ApplicationController
  include ExcelFileService

  before_action :jwt_required
  before_action :current_assignment

  def show
    params.permit(%i[file_id])
    file = ExcelFile.find_by_id(params[:file_id])
    send_file(file.path,
              filename: file.file_name)
  end

  def update
    params.require(%i[assignment_id])

    super(assignment_id: params[:assignment_id])

    render status: :ok
  end
end

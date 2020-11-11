require './app/services/excel_file_service'

class ExcelFilesController < ApplicationController
  include ExcelFileService

  before_action :admin?

  def show
    params.require(%i[assignment_id])

    super(assignment_id: params[:assignment_id])
  end

  def update
    params.require(%i[assignment_id])

    super(assignment_id: params[:assignment_id])

    render status: :ok
  end
end

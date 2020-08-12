class ExcelFilesController < ApplicationController
  before_action :jwt_required
  before_action :current_assignment

  def update
    @assignment.generate_excel_file

    render status: :ok
  end

  def show
    excel_file = @assignment.excel_file
    return render status: :not_found unless excel_file

    send_file(excel_file.path,
              filename: excel_file.file_name,
              status: :no_content)
  end
end

class ExcelFilesController < ApplicationController
  include FileScaffold::ControllerMethod

  before_action :jwt_required
  before_action :current_assignment

  def show
    super { @assignment.excel_file }
  end

  def update
    @assignment.generate_excel_file

    render status: :ok
  end
end

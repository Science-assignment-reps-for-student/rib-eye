class ExcelFilesController < ApplicationController
  include FileScaffold::ControllerMethod

  before_action :jwt_required
  before_action :current_assignment

  def update
    @assignment.generate_excel_file

    render status: :ok
  end

  def show
    super { @assignment.excel_file }
  end
end

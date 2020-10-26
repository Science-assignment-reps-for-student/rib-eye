require 'utils/excel_util'

class ExcelFileService
  def initialize(assignment_id:)
    @assignment = Assignment.find_by_id(assignment_id)
  end

  def update
    excel_util = ExcelUtil.new(@assignment)
    excel_util.generate_excel_file
  end
end
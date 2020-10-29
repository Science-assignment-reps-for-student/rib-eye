require './app/utils/excel_util'

module ExcelFileService
  def update(assignment_id:)
    assignment = Assignment.find_by_id(assignment_id)
    excel_util = ExcelUtil.new(assignment)
    excel_util.generate_excel_file
  end
end
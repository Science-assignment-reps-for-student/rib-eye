# frozen_string_literal: true

require './app/utils/excel_util'

module ExcelFileService
  def show(assignment_id:)
    file = Assignment.find_by_id(assignment_id)&.excel_file
    send_file(file.path,
              filename: file.file_name)
  end

  def update(assignment_id:)
    assignment = Assignment.find_by_id(assignment_id)
    ExcelUtil.new(assignment: assignment).generate_excel_file
  end
end

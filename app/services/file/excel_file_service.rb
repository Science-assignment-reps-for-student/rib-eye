require 'utils/excel_util'

class ExcelFileService < Service
  attr_reader :assignment

  def initialize(assignment_id:)
    @assignment = Assignment.find_by_id(assignment_id)
  end

  def self.instance(**kwargs)
    super(kwargs) do |instance|
      instance.assignment.id == kwargs[:assignment_id]
    end
  end

  def update
    excel_util = ExcelUtil.new(@assignment)
    excel_util.generate_excel_file
  end
end
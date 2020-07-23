class ExcelFile < ApplicationRecord
  belongs_to :assignment

  def stored_dir
    super + "excel_file/#{assignment_id}/"
  end
end

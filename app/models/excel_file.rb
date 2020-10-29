class ExcelFile < ApplicationRecord
  belongs_to :assignment

  def stored_dir
    File.join(super, "excel_file/#{assignment_id}")
  end
end

class AssignmentFile < ApplicationRecord
  include FileHelper
  extend FileHelper::FileGenerator

  belongs_to :assignment

  def stored_dir
    File.join(super, "assignment_file/#{assignment_id}/#{id}")
  end
end

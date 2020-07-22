class AssignmentFile < ApplicationRecord
  belongs_to :assignment

  def stored_dir
    super + "/homework_file/#{assignment_id}"
  end
end

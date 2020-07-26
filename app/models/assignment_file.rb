class AssignmentFile < ApplicationRecord
  belongs_to :assignment

  def stored_dir
    File.join(super, "assignment_file/#{assignment_id}")
  end
end

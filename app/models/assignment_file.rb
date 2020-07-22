class AssignmentFile < ApplicationRecord
  belongs_to :assignment

  def stored_dir
    super + "/homework_file/#{homework_id}"
  end
end

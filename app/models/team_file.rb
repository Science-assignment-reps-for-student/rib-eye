class TeamFile < ApplicationRecord
  belongs_to :assignment
  belongs_to :team

  def stored_dir
    super + "/multi_file/#{homework_id}/#{team_id}"
  end

  def singular_file_name(extension)
    "[#{homework.type_korean}][#{homework.title}]"\
    "#{team.student.class_number}반_#{team.name}" + extension
  end
end

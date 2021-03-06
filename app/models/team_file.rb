class TeamFile < FileExtension
  belongs_to :assignment
  belongs_to :team

  def stored_dir
    File.join(super, "team_file/#{assignment_id}/#{team_id}")
  end

  def singular_file_name(file)
    "[#{assignment.type_korean}][#{assignment.title}]"\
    "#{team.student.class_number}반_#{team.name}" + File.extname(file) + ""
  end
end

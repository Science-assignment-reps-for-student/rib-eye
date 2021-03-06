class ExperimentFile < FileExtension
  belongs_to :assignment
  belongs_to :student

  def stored_dir
    File.join(super, "experiment_file/#{assignment_id}/#{student_id}")
  end

  def singular_file_name(file)
    "[#{assignment.type_korean}][#{assignment.title}]"\
    "#{student.student_number}_#{student.name}" + File.extname(file) + ""
  end
end

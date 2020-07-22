class ExperimentFile < ApplicationRecord
  belongs_to :assignment
  belongs_to :student

  def stored_dir
    super + "/experiment_file/#{assignment_id}/#{student_id}"
  end

  def singular_file_name(extension)
    "[#{assignment.type_korean}][#{assignment.title}]"\
    "#{student.student_number}_#{student.name}" + extension
  end
end

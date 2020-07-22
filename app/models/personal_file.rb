class PersonalFile < ApplicationRecord
  belongs_to :assignment
  belongs_to :student

  def stored_dir
    super + "/single_file/#{homework_id}/#{student_id}"
  end

  def singular_file_name(extension)
    "[#{homework.type_korean}][#{homework.title}]"\
    "#{student.student_number}_#{student.name}" + extension
  end
end

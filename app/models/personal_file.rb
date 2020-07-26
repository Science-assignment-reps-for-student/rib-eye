class PersonalFile < ApplicationRecord
  include FileHelper
  extend FileHelper::FileGenerator

  belongs_to :assignment
  belongs_to :student

  def stored_dir
    File.join(super, "personal_file/#{assignment_id}/#{student_id}")
  end

  def singular_file_name(extension)
    "'[#{assignment.type_korean}][#{assignment.title}]"\
    "#{student.student_number}_#{student.name}" + extension + "'"
  end
end

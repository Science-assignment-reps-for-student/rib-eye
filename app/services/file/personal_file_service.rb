class PersonalFileService
  def self.index(model:, student_id:, assignment_id:)
    files = model.where(student_id: student_id, assignment_id: assignment_id)
    files.map do |file|
      {
        file_name: file.file_name,
        file_id: file.id
      }
    end
  end

  def self.create(model:, files:, **options)
    student = Student.find_by_id(options[:student_id])
    assignment = Assignment.find_by_id(options[:assignment_id])

    existing_files = model.where(student: student, assignment: assignment)
    conflicting_files = files.map do |file|
      existing_files.find_by_file_name(File.basename(file)).file_name
    end.compact

    model.create_with_file!(files, existing_files.blank?, **options)

    NoticeMailer.submission(student, assignment).deliver_later
  end

  def self.destroy(model:, file_id:)
    existing_file = model.find_by_id(file_id)
    existing_file.destroy!
  end
end
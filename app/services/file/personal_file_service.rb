class PersonalFileService < Service
  def initialize(student_id:, assignment_id:, model:)
    @student = Student.find_by_id(student_id)
    @assignment = Assignment.find_by_id(assignment_id)
    @model = model
  end

  def status
    files = @model.where(student: @student, assignment: @assignment)
    files.map do |file|
      {
        file_name: file.file_name,
        file_id: file.id
      }
    end
  end

  def create(files, **options)
    existing_files = @model.where(student: @student, assignment: @assignment)
    conflicting_files = files.map do |file|
      existing_files.find_by_file_name(File.basename(file)).file_name
    end.compact
    @model.create_with_file!(files, existing_files.blank?, **options)
    NoticeMailer.submission(@student, @assignment).deliver_later
  end

  def destroy(file_id)
    existing_file = @model.find_by_id(file_id)
    existing_file.destroy!
  end
end
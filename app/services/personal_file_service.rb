# frozen_string_literal: true

module PersonalFileService
  def show(model:, file_id:)
    file = model.find_by_id(file_id)
    send_file(file.path,
              filename: file.file_name)
  end

  def index(model:, student_email: nil, student_id: nil, assignment_id:)
    student = Student.find_by_email(student_email) || Student.find_by_id(student_id)
    assignment = Assignment.find_by_id(assignment_id)

    files = model.where(student: student, assignment: assignment)
    {
      file_information: files.map do |file|
        {
          file_name: file.file_name,
          file_id: file.id
        }
      end
    }
  end

  def create(model:, files:, **options)
    student = Student.find_by_email(options[:student_email])
    assignment = Assignment.find_by_id(options[:assignment_id])

    options.delete(:student_email)
    options[:student_id] = student.id

    existing_files = model.where(student: student, assignment: assignment)
    conflicting_files = (files & existing_files).map(&:file_name)

    model.create_with_file!(files, existing_files.blank?, **options)

    NoticeMailer.submission(student, assignment).deliver_later
  end

  def destroy(model:, file_id:)
    existing_file = model.find_by_id(file_id)
    existing_file.destroy!
  end
end

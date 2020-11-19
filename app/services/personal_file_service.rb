# frozen_string_literal: true

module PersonalFileService
  include Response

  def show(model:, file_id:)
    file = model.find_by_id(file_id)

    NotFoundException::NotFound.except(file: file)

    send_file(file.path,
              filename: file.file_name,
              buffer_size: buffer_size,
              stream: true)
  end

  def index(model:, student_email: nil, student_id: nil, assignment_id:)
    student = Student.find_by_email(student_email) || Student.find_by_id(student_id)
    assignment = Assignment.find_by_id(assignment_id)

    NotFoundException::NotFound.except(student: student, assignment: assignment)

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

    NotFoundException::NotFound.except(student: student, assignment: assignment)

    options.delete(:student_email)
    options[:student_id] = student.id

    existing_files = model.where(student: student, assignment: assignment)

    ConflictException::Conflict.except(files: files, existing_files: existing_files)

    model.create_with_file!(files, existing_files.blank?, **options)

    NoticeMailer.submission(student, assignment).deliver_later
  end

  def destroy(model:, file_id:)
    existing_file = model.find_by_id(file_id)

    NotFoundException::NotFound.except(file: existing_file)

    existing_file.destroy!
  end
end

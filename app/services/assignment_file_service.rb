# frozen_string_literal: true

module AssignmentFileService
  def show(file_id:)
    file = AssignmentFile.find_by_id(file_id)

    NotFoundException::NotFound.except(file: file)

    send_file(file.path,
              filename: file.file_name,
              buffer_size: buffer_size)
  end

  def index(assignment_id:)
    assignment = Assignment.find_by_id(assignment_id)

    NotFoundException::NotFound.except(assignment: assignment)

    assignment.assignment_files.map do |file|
      {
        file_name: file.file_name,
        file_id: file.id
      }
    end
  end

  def destroy(file_id:)
    existing_file = AssignmentFile.find_by_id(file_id)

    NotFoundException::NotFound.except(file: existing_file)

    existing_file.destroy!
  end
end

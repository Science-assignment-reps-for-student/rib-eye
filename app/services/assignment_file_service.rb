# frozen_string_literal: true

module AssignmentFileService
  def show(file_id:)
    file = AssignmentFile.find_by_id(file_id)
    send_file(file.path,
              filename: file.file_name)
  end

  def index(assignment_id:)
    assignment = Assignment.find_by_id(assignment_id)
    assignment.assignment_files.map do |file|
      {
        file_name: file.file_name,
        file_id: file.id
      }
    end
  end

  def destroy(file_id:)
    existing_file = AssignmentFile.find_by_id(file_id)
    existing_file.destroy!
  end
end

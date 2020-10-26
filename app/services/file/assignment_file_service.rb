class AssignmentFileService < Service
  def initialize(assignment_id:)
    @assignment = Assignment.find_by_id(assignment_id)
  end

  def index
    @assignment.assignment_files.map do |file|
      {
        file_name: file.file_name,
        file_id: file.id
      }
    end
  end

  def destroy(file_id)
    existing_file = AssignmentFile.find_by_id(file_id)
    existing_file.destroy!
  end
end
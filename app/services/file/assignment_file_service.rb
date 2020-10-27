class AssignmentFileService
  def self.index(assignment_id:)
    assignment = Assignment.find_by_id(assignment_id)
    assignment.assignment_files.map do |file|
      {
        file_name: file.file_name,
        file_id: file.id
      }
    end
  end

  def self.destroy(file_id:)
    existing_file = AssignmentFile.find_by_id(file_id)
    existing_file.destroy!
  end
end
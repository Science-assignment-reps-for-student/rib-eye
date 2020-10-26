class AssignmentFileService < Service
  attr_reader :assignment

  def initialize(assignment_id:)
    @assignment = Assignment.find_by_id(assignment_id)
  end

  def self.instance(**kwargs)
    super(kwargs) do |instance|
      instance.assignment.id == kwargs[:assignment_id]
    end
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
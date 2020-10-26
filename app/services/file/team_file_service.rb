class TeamFileService < Service
  def initialize(student_id:, assignment_id:)
    @team = Team.find_by_student_id_and_assignment_id(student_id, assignment_id)
    @assignment = Assignment.find_by_id(assignment_id)
  end

  def self.instance(**kwargs)
    super(kwargs) do |instance|
      (instance.team.id == kwargs[:team_id]) &&
        (instance.assignment.id = kwargs[:assignment_id])
    end
  end

  def index
    files = TeamFile.where(team: @team, assignment: @assignment)
    files.map do |file|
      {
        file_name: file.file_name,
        file_id: file.id
      }
    end
  end

  def create(files, **options)
    existing_files = TeamFile.where(student: @team, assignment: @assignment)
    conflicting_files = files.map do |file|
      existing_files.find_by_file_name(File.basename(file)).file_name
    end.compact
    TeamFile.create_with_file!(files, existing_files.blank?, **options)
    @team.students.each do |student|
      NoticeMailer.submission(student, @assignment).deliver_later
    end
  end

  def destroy(file_id)
    existing_file = TeamFile.find_by_id(file_id)
    existing_file.destroy!
  end
end
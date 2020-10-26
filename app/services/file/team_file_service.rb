class TeamFileService < Service
  def initialize(team_id:, assignment_id:)
    @team = Team.find_by_id(team_id)
    @assignment = Assignment.find_by_id(assignment_id)
  end

  def status
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
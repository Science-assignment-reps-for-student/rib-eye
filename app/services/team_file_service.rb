module TeamFileService
  def index(team_id:, assignment_id:)
    files = TeamFile.where(team_id: team_id, assignment_id: assignment_id)
    files.map do |file|
      {
        file_name: file.file_name,
        file_id: file.id
      }
    end
  end

  def create(files:, **options)
    team = Team.find_by_id(options[:team_id])
    assignment = Assignment.find_by_id(options[:assignment_id])

    existing_files = TeamFile.where(team: team, assignment: assignment)
    conflicting_files = (files & existing_files).map(&:file_name)

    TeamFile.create_with_file!(files, existing_files.blank?, **options)

    team.students.each do |student|
      NoticeMailer.submission(student, assignment).deliver_later
    end
  end

  def destroy(file_id:)
    existing_file = TeamFile.find_by_id(file_id)
    existing_file.destroy!
  end
end
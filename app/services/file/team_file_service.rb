class TeamFileService
  def self.index(team_id:, assignment_id:)
    files = TeamFile.where(team_id: team_id, assignment_id: assignment_id)
    files.map do |file|
      {
        file_name: file.file_name,
        file_id: file.id
      }
    end
  end

  def self.create(files:, **options)
    existing_files = TeamFile.where(team_id: options[:team_id], assignment_id: options[:assignment_id])
    conflicting_files = files.map do |file|
      existing_files.find_by_file_name(File.basename(file)).file_name
    end.compact

    TeamFile.create_with_file!(files, existing_files.blank?, **options)

    Team.find_by_id(options[:team_id]).students.each do |student|
      NoticeMailer.submission(student, Assignment.find_by_id(options[:assignment_id])).deliver_later
    end
  end

  def self.destroy(file_id)
    existing_file = TeamFile.find_by_id(file_id)
    existing_file.destroy!
  end
end
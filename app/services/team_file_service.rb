# frozen_string_literal: true

module TeamFileService
  def show(file_id:)
    file = TeamFile.find_by_id(file_id)
    send_file(file.path,
              filename: file.file_name)
  end

  def index(team_id: nil, student_email: nil, assignment_id:)
    team = Team.find_by_id(team_id)
    team ||= Student.find_by_email(student_email)&.team(assignment_id)
    assignment = Assignment.find_by_id(assignment_id)

    files = TeamFile.where(team: team, assignment: assignment)
    {
      file_information: files.map do |file|
        {
          file_name: file.file_name,
          file_id: file.id
        }
      end
    }
  end

  def create(files:, **options)
    team = Student.find_by_email(options[:student_email])
                  &.team(options[:assignment_id])
    assignment = Assignment.find_by_id(options[:assignment_id])

    options.delete(:student_email)
    options[:team_id] = team.id

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

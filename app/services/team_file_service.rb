# frozen_string_literal: true

module TeamFileService
  def show(file_id:)
    file = TeamFile.find_by_id(file_id)

    NotFoundException::NotFound.except(file: file)

    send_file(file.path,
              filename: file.file_name,
              buffer_size: buffer_size,
              stream: true)
  end

  def index(team_id: nil, student_email: nil, assignment_id:)
    team = Team.find_by_id(team_id) || Student.find_by_email(student_email)&.team(assignment_id)
    assignment = Assignment.find_by_id(assignment_id)

    NotFoundException::NotFound.except(team: team, assignment: assignment)

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

    NotFoundException::NotFound.except(team: team, assignment: assignment)

    options.delete(:student_email)
    options[:team_id] = team.id

    existing_files = TeamFile.where(team: team, assignment: assignment)

    ConflictException::Conflict.except(files: files, existing_files: existing_files)

    TeamFile.create_with_file!(files, existing_files.blank?, **options)

    team.students.each do |student|
      NoticeMailer.submission(student, assignment).deliver_later
    end
  end

  def destroy(file_id:)
    existing_file = TeamFile.find_by_id(file_id)

    NotFoundException::NotFound.except(file: existing_file)

    existing_file.destroy!
  end
end

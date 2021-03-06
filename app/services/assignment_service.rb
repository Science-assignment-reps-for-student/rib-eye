# frozen_string_literal: true

require './app/utils/zip_util'

module AssignmentService
  def show(assignment_id:)
    assignment = Assignment.find_by_id(assignment_id)

    NotFoundException::NotFound.except(assignment: assignment)

    ZipUtil.new(assignment: assignment).generate_compressed_file

    send_file(assignment.compressed_file_path,
              filename: File.basename(assignment.compressed_file_name),
              buffer_size: buffer_size,
              stream: true)
  end

  def index(assignment_id:)
    assignment = Assignment.find_by_id(assignment_id)

    NotFoundException::NotFound.except(assignment: assignment)

    { compressed_file_name: assignment.compressed_file_name }
  end

  def create(files:, **params)
    BadRequestException::BadAssignmentName.except(params[:title])
    BadRequestException::BadAssignmentType.except(params[:type])

    assignment = Assignment.create!(params)

    return assignment if files.nil?

    files.each { |file| AssignmentFile.create!(file, assignment: assignment) }
  end

  def update(assignment_id:, files:, **params)
    BadRequestException::BadAssignmentName.except(params[:title])
    BadRequestException::BadAssignmentType.except(params[:type])

    assignment = Assignment.find_by_id(assignment_id)

    NotFoundException::NotFound.except(assignment: assignment)

    assignment.update!(title: params[:title],
                       description: params[:description],
                       type: params[:type],
                       deadline_1: params[:deadline_1],
                       deadline_2: params[:deadline_2],
                       deadline_3: params[:deadline_3],
                       deadline_4: params[:deadline_4])

    return nil if files.blank?

    assignment.assignment_files.each(&:destroy!)
    files.each { |file| AssignmentFile.create!(file, assignment: assignment.reload) }
  end

  def destroy(assignment_id:)
    assignment = Assignment.find_by_id(assignment_id)

    NotFoundException::NotFound.except(assignment: assignment)

    assignment.assignment_files.each(&:destroy!)
    assignment.destroy!
  end
end

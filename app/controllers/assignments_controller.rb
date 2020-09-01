class AssignmentsController < ApplicationController
  include FileScaffold::HelperMethod

  before_action :jwt_required
  before_action :file_input_stream, only: %i[create update]
  before_action :current_assignment, except: :create
  before_action :current_admin

  def show
    @assignment.generate_compressed_file

    send_file(@assignment.compressed_file_path,
              filename: @assignment.compressed_file_name)
  end

  def index
    submitted_by = if @assignment.type == 'TEAM'
                     Team.find_by_id(params[:team_id])
                   else
                     Student.find_by_id(params[:student_id])
                   end
    return render status: :not_found unless submitted_by

    file_information = submitted_by.send("#{@assignment.type.downcase}_files").map do |file|
      {
        file_id: file.id,
        file_name: file.file_name
      }
    end

    render status: :ok,
           json: { file_information: file_information }
  end

  def create
    params.require(%i[title description type deadline_1 deadline_2 deadline_3 deadline_4])
    return render status: :bad_request unless Assignment.types.keys.include?(params[:type])

    assignment = Assignment.create!(title: params[:title],
                                    description: params[:description],
                                    type: params[:type],
                                    deadline_1: params[:deadline_1],
                                    deadline_2: params[:deadline_2],
                                    deadline_3: params[:deadline_3],
                                    deadline_4: params[:deadline_4])

    @files&.each { |file| AssignmentFile.create!(file, assignment: assignment) }

    render status: :created
  end

  def update
    params.require(%i[title description type deadline_1 deadline_2 deadline_3 deadline_4])
    return render status: :bad_request unless Assignment.types.keys.include?(params[:type])

    @assignment.update!(title: params[:title],
                        description: params[:description],
                        type: params[:type],
                        deadline_1: params[:deadline_1],
                        deadline_2: params[:deadline_2],
                        deadline_3: params[:deadline_3],
                        deadline_4: params[:deadline_4])

    @assignment.assignment_files.each(&:destroy!)
    @files&.each { |file| AssignmentFile.create!(file, assignment: @assignment.reload) }

    render status: :ok
  end

  def destroy
    @assignment.assignment_files.each(&:destroy!)
    @assignment.destroy!

    render status: :ok
  end
end

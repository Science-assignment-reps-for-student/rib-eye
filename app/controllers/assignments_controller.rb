class AssignmentsController < ApplicationController
  include FileScaffold::HelperMethod

  before_action :jwt_required
  before_action :file_input_stream, only: %i[create update]
  before_action :current_assignment, except: :create
  before_action :current_admin

  def show
    file = @assignment.generate_compressed_file

    response.headers['Content-Length'] = File.size(file.path)
    send_file(file.path,
              filename: File.basename(file))
  end

  def index
    @assignment.compressed_file_name

    render status: :ok,
           json: { compressed_file_name: @assignment.compressed_file_name }
  end

  def create
    params.require(%i[title description type deadline_1 deadline_2 deadline_3 deadline_4])
    return render status: :bad_request unless Assignment.types.keys.include?(params[:type])
    return render status: :bad_request if params[:title].match(%r{/})

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

    unless @files.blank?
      @assignment.assignment_files.each(&:destroy!)
      @files&.each { |file| AssignmentFile.create!(file, assignment: @assignment.reload) }
    end

    render status: :ok
  end

  def destroy
    @assignment.assignment_files.each(&:destroy!)
    @assignment.destroy!

    render status: :ok
  end
end

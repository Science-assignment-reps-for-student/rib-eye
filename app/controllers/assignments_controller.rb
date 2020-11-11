require './app/services/assignment_service'

class AssignmentsController < ApplicationController
  include FileScaffold::HelperMethod
  include AssignmentService

  before_action :admin?
  before_action :file_input_stream, only: %i[create update]

  def show
    params.require(%i[assignment_id])

    super(assignment_id: params[:assignment_id])
  end

  def index
    params.require(%i[assignment_id])

    render json: super(assignment_id: params[:assignment_id]),
           status: :ok
  end

  def create
    params.require(%i[title description type deadline_1 deadline_2 deadline_3 deadline_4])
    return render status: :bad_request unless Assignment.types.keys.include?(params[:type])
    return render status: :bad_request if params[:title].match(%r{/})

    super(files: @files,
          title: params[:title],
          description: params[:description],
          type: params[:type],
          deadline_1: params[:deadline_1],
          deadline_2: params[:deadline_2],
          deadline_3: params[:deadline_3],
          deadline_4: params[:deadline_4])

    render status: :created
  end

  def update
    params.require(%i[title description type deadline_1 deadline_2 deadline_3 deadline_4])
    return render status: :bad_request unless Assignment.types.keys.include?(params[:type])

    super(assignment_id: params[:assignment_id],
          files: @files,
          title: params[:title],
          description: params[:description],
          type: params[:type],
          deadline_1: params[:deadline_1],
          deadline_2: params[:deadline_2],
          deadline_3: params[:deadline_3],
          deadline_4: params[:deadline_4])

    render status: :ok
  end

  def destroy
    params.require(%i[assignment_id])
    super(assignment_id: params[:assignment_id])

    render status: :ok
  end
end

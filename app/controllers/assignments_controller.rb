require './app/services/assignment_service'

class AssignmentsController < ApplicationController
  include AssignmentService

  before_action :file_filter, only: :create

  before_action :admin?

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

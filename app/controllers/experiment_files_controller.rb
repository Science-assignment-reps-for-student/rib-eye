class ExperimentFilesController < ApplicationController
  include FileScaffold::ControllerMethod
  include FileScaffold::HelperMethod

  before_action :jwt_required
  before_action :file_input_stream, only: :create
  before_action :current_assignment, only: %i[create status_for_admin status_for_student]
  before_action :current_student, only: %i[create destroy status_for_student]
  before_action :current_admin, only: %i[show status_for_admin]

  def show
    super { ExperimentFile.find_by_id(params[:file_id]) }
  end

  def status_for_admin
    params.require(:student_id)

    student = Student.find_by_id(params[:student_id])
    return render status: :not_found unless student

    index do
      ExperimentFile.where(student: student,
                           assignment: @assignment)
    end
  end

  def status_for_student
    index do
      ExperimentFile.where(student: @student,
                           assignment: @assignment)
    end
  end

  def create
    conflict_condition = proc do
      ExperimentFile.find_by_student_id_and_assignment_id(@student.id,
                                                          @assignment.id)
    end

    super(ExperimentFile, conflict_condition,
          student: @student,
          assignment: @assignment,
          created_at: Time.zone.now)
  end

  def destroy
    super(ExperimentFile)
  end
end

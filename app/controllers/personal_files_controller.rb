class PersonalFilesController < ApplicationController
  include FileScaffold::ControllerMethod
  include FileScaffold::HelperMethod

  before_action :jwt_required
  before_action :file_input_stream, only: :create
  before_action :current_assignment, only: %i[create index]
  before_action :current_student, only: %i[create destroy]
  before_action :current_admin, only: :show

  def show
    super { PersonalFile.find_by_id(params[:file_id]) }
  end

  def index
    params.require(:student_id)
    student = Student.find_by_id(params[:student_id])

    super do
      PersonalFile.where(student: student,
                         assignment: @assignment)
    end
  end

  def create
    conflict_condition = proc do
      PersonalFile.find_by_student_id_and_assignment_id(@student.id,
                                                        @assignment.id)
    end

    super(PersonalFile, conflict_condition,
          student: @student,
          assignment: @assignment,
          created_at: Time.zone.now)
  end

  def destroy
    super(PersonalFile)
  end
end

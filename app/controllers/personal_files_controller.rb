class PersonalFilesController < ApplicationController
  include FileScaffold::ControllerMethod
  include FileScaffold::HelperMethod

  before_action :jwt_required
  before_action :file_input_stream, only: :create
  before_action :current_assignment, only: %i[create destroy index]
  before_action :current_student, only: %i[create destroy]
  before_action :current_admin, only: %i[show index]

  def show
    super { PersonalFile.find_by_id(params[:file_id]) }
  end

  def index
    params.require(:student_id)

    student = Student.find_by_id(params[:student_id])
    return render status: :not_found unless student

    super do
      PersonalFile.where(student: student,
                         assignment: @assignment)
    end
  end

  def create
    super(ExperimentFile,
          student_id: @student.id,
          assignment_id: @assignment.id,
          created_at: Time.zone.now) do
      PersonalFile.find_by_student_id_and_assignment_id(@student.id,
                                                        @assignment.id)
    end
  end

  def destroy
    super { @student.personal_files.where(assignment: @assignment) }
  end
end

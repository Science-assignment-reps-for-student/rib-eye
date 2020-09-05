class PersonalFilesController < ApplicationController
  include FileScaffold::ControllerMethod
  include FileScaffold::HelperMethod

  before_action :jwt_required
  before_action :file_input_stream, only: :create
  before_action :current_assignment, only: %i[create status_for_admin status_for_student]
  before_action :current_student, only: %i[create destroy status_for_student]
  before_action :current_admin, only: %i[show status_for_admin]

  def show
    super { PersonalFile.find_by_id(params[:file_id]) }
  end

  def status_for_admin
    params.require(:student_id)

    student = Student.find_by_id(params[:student_id])
    return render status: :not_found unless student

    index do
      PersonalFile.where(student: student,
                         assignment: @assignment)
    end
  end

  def status_for_student
    index do
      PersonalFile.where(student: @student,
                         assignment: @assignment)
    end
  end

  def create
    super(PersonalFile,
          student: @student,
          assignment: @assignment,
          created_at: Time.zone.now)
  end

  def destroy
    super(PersonalFile)
  end
end

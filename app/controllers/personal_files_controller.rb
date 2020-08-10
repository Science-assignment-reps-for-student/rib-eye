class PersonalFilesController < ApplicationController
  before_action :jwt_required
  before_action :file_input_stream, only: :create
  before_action :current_assignment, only: %i[create destroy]
  before_action :current_student, only: %i[create destroy]
  before_action :current_admin, only: :show

  def show
    params.require(%i[student_id assignment_id])

    personal_file = PersonalFile.find_by_student_id_and_assignment_id(params[:student_id],
                                                                      params[:assignment_id])
    return render status: :not_found unless personal_file

    send_file(personal_file.path,
              filename: personal_file.file_name,
              status: :no_content)
  end

  def create
    if @student.personal_files.find_by_assignment_id(params[:assignment_id])
      return render status: :conflict
    end

    if @files.length == 1
      PersonalFile.create!(@files[0],
                           student_id: @student.id,
                           assignment_id: params[:assignment_id],
                           created_at: Time.zone.now)
    else
      @files.each do |file|
        PersonalFile.create!(file,
                             student_id: @student.id,
                             assignment_id: params[:assignment_id],
                             file_name: File.basename(file),
                             created_at: Time.zone.now)
      end
    end

    render status: :created
  end

  def destroy
    assignment = @student.personal_files.find_by_assignment_id(params[:assignment_id])
    return render status: :precondition_failed unless assignment

    assignment.destroy!

    render status: :ok
  end
end

class PersonalFilesController < ApplicationController
  before_action :jwt_required

  def show
    params.require(%i[student_id assignment_id])
    return render status: :forbidden unless current_admin

    personal_file = PersonalFile.find_by_student_id_and_assignment_id(params[:student_id],
                                                                      params[:assignment_id])
    return render status: :not_found unless personal_file

    send_file(personal_file.path,
              filename: personal_file.file_name,
              status: :no_content)
  end

  def index

  end

  def create

  end

  def destroy

  end
end

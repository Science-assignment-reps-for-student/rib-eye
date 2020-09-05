class TeamFilesController < ApplicationController
  include FileScaffold::ControllerMethod
  include FileScaffold::HelperMethod

  before_action :jwt_required
  before_action :file_input_stream, only: :create
  before_action :current_assignment, only: %i[create status_for_admin status_for_student]
  before_action :current_team, only: %i[create destroy status_for_student]
  before_action :current_admin, only: %i[show status_for_admin]

  def show
    super { TeamFile.find_by_id(params[:file_id]) }
  end

  def status_for_admin
    params.require(:team_id)

    team = Team.find_by_id(params[:team_id])
    return render status: :not_found unless team

    index do
      TeamFile.where(team: team,
                     assignment: @assignment)
    end
  end

  def status_for_student
    index do
      TeamFile.where(team: @team,
                     assignment: @assignment)
    end
  end

  def create
    super(TeamFile,
          team: @team,
          assignment: @assignment,
          created_at: Time.zone.now)
  end

  def destroy
    super(TeamFile)
  end
end

class TeamFilesController < ApplicationController
  include FileScaffold::ControllerMethod
  include FileScaffold::HelperMethod

  before_action :jwt_required
  before_action :file_input_stream, only: :create
  before_action :current_assignment, only: %i[create destroy index]
  before_action :current_admin, only: %i[show index]
  before_action :current_team, only: %i[create destroy]

  def show
    super { TeamFile.find_by_id(params[:file_id]) }
  end

  def index
    params.require(:team_id)

    team = Team.find_by_id(params[:team_id])
    return render status: :not_found unless team

    super do
      TeamFile.where(team: team,
                     assignment: @assignment)
    end
  end

  def create
    super(TeamFile,
          team_id: @team.id,
          assignment_id: @assignment.id,
          created_at: Time.zone.now) do
      TeamFile.find_by_team_id_and_assignment_id(@team.id,
                                                 @assignment.id)
    end
  end

  def destroy
    super { @team.team_files.where(assignment: @assignment) }
  end
end

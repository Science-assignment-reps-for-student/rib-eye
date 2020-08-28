class TeamFilesController < ApplicationController
  include FileScaffold::ControllerMethod
  include FileScaffold::HelperMethod

  before_action :jwt_required
  before_action :file_input_stream, only: :create
  before_action :current_assignment, only: %i[create index]
  before_action :current_team, only: %i[create destroy]
  before_action :current_admin, only: :show

  def show
    super { TeamFile.find_by_id(params[:file_id]) }
  end

  def index
    params.require(:team_id)
    team = Team.find_by_id(params[:team_id])

    super do
      TeamFile.where(team: team,
                     assignment: @assignment)
    end
  end

  def create
    conflict_condition = proc do
      TeamFile.find_by_team_id_and_assignment_id(@team.id, @assignment.id)
    end

    super(TeamFile, conflict_condition,
          team: @team,
          assignment: @assignment,
          created_at: Time.zone.now)
  end

  def destroy
    super(TeamFile)
  end
end

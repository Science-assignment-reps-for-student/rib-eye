require 'rails_helper'

RSpec.describe TeamFile, type: :model do
  before(:all) do
    @assignment = create(:assignment, type: 'TEAM')
    @leader = create(:student)
    @team = create(:team, assignment_id: @assignment.id, leader_id: @leader.id)
    @team_file = create(:team_file,
                        assignment_id: @assignment.id,
                        team_id: @team.id)
  end

  describe 'relationship verification' do
    it 'belongs to assignment' do
      relationship = TeamFile.reflect_on_association(:assignment).macro
      expect(relationship).to eql(:belongs_to)
    end

    it 'belongs to team' do
      relationship = TeamFile.reflect_on_association(:team).macro
      expect(relationship).to eql(:belongs_to)
    end
  end

  describe 'file process' do
    it 'storing file' do
      file_storing_test(@team_file)
    end
  end
end

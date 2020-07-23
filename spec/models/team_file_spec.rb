require 'rails_helper'

RSpec.describe TeamFile, type: :model do
  before(:all) do
    @assignment = create(:assignment, type: 'TEAM')
    @student = create(:student)
    @team_file = create(:experiment_file,
                        assignment_id: @assignment.id,
                        student_id: @student.id)
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
    it 'storing singular file' do
      singular_file_test(@team_file)
    end

    it 'storing plural files' do
      plural_files_test(@team_file)
    end
  end
end

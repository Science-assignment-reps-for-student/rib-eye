require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'relationship verification' do
    it 'has many team files' do
      relationship = Team.reflect_on_association(:team_files).macro
      expect(relationship).to eql(:has_many)
    end

    it 'has many members' do
      relationship = Team.reflect_on_association(:members).macro
      expect(relationship).to eql(:has_many)
    end

    it 'has many students' do
      relationship = Team.reflect_on_association(:students).macro
      expect(relationship).to eql(:has_many)
    end
  end
end

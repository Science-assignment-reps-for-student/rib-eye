require 'rails_helper'

RSpec.describe TeamFile, type: :model do
  describe 'relationship verification' do
    it 'belongs to homework' do
      relationship = TeamFile.reflect_on_association(:homework).macro
      expect(relationship).to eql(:belongs_to)
    end

    it 'belongs to team' do
      relationship = TeamFile.reflect_on_association(:team).macro
      expect(relationship).to eql(:belongs_to)
    end
  end
end

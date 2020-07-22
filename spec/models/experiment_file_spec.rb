require 'rails_helper'

RSpec.describe ExperimentFile, type: :model do
  describe 'relationship verification' do
    it 'belongs to assignment' do
      relationship = ExperimentFile.reflect_on_association(:assignment).macro
      expect(relationship).to eql(:belongs_to)
    end

    it 'belongs to student' do
      relationship = ExperimentFile.reflect_on_association(:student).macro
      expect(relationship).to eql(:belongs_to)
    end
  end
end

require 'rails_helper'

RSpec.describe MutualEvaluation, type: :model do
  describe 'relationship verification' do
    it 'belongs to student' do
      relationship = MutualEvaluation.reflect_on_association(:student).macro
      expect(relationship).to eql(:belongs_to)
    end
  end
end

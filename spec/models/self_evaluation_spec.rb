require 'rails_helper'

RSpec.describe SelfEvaluation, type: :model do
  describe 'relationship verification' do
    it 'belongs to student' do
      relationship = SelfEvaluation.reflect_on_association(:student).macro
      expect(relationship).to eql(:belongs_to)
    end
  end
end

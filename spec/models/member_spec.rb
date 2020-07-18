require 'rails_helper'

RSpec.describe Member, type: :model do
  describe 'relationship verification' do
    it 'belongs to student' do
      relationship = Member.reflect_on_association(:student).macro
      expect(relationship).to eql(:belongs_to)
    end

    it 'belongs to team' do
      relationship = Member.reflect_on_association(:team).macro
      expect(relationship).to eql(:belongs_to)
    end
  end
end

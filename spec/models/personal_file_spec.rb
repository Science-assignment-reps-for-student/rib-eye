require 'rails_helper'

RSpec.describe PersonalFile, type: :model do
  describe 'relationship verification' do
    it 'belongs to homework' do
      relationship = PersonalFile.reflect_on_association(:assignment).macro
      expect(relationship).to eql(:belongs_to)
    end

    it 'belongs to student' do
      relationship = PersonalFile.reflect_on_association(:student).macro
      expect(relationship).to eql(:belongs_to)
    end
  end
end

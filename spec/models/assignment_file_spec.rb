require 'rails_helper'

RSpec.describe AssignmentFile, type: :model do
  describe 'relationship verification' do
    it 'belongs to assignment' do
      relationship = AssignmentFile.reflect_on_association(:assignment).macro
      expect(relationship).to eql(:belongs_to)
    end
  end
end

require 'rails_helper'

RSpec.describe AssignmentFile, type: :model do
  before(:all) do
    @assignment = create(:assignment)
    @assignment_file = create(:assignment_file, assignment_id: @assignment.id)
  end

  describe 'relationship verification' do
    it 'belongs to assignment' do
      relationship = AssignmentFile.reflect_on_association(:assignment).macro
      expect(relationship).to eql(:belongs_to)
    end
  end

  describe 'file process' do
    it 'check stored directory' do
      expect(@assignment_file.stored_dir).to eql(ApplicationRecord.stored_dir +
                                                 '/assignment_file/1')
    end
  end
end

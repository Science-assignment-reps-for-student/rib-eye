require 'rails_helper'

RSpec.describe ExcelFile, type: :model do
  before(:all) do
    @assignment = create(:assignment)
    @excel_file = create(:excel_file, assignment_id: @assignment.id)
  end

  describe 'relationship verification' do
    it 'belongs to assignment' do
      relationship = ExcelFile.reflect_on_association(:assignment).macro
      expect(relationship).to eql(:belongs_to)
    end
  end

  describe 'file process' do
    it 'check stored directory' do
      expect(@excel_file.stored_dir).to eql(ApplicationRecord.stored_dir +
                                            '/excel_file/1')
    end
  end
end

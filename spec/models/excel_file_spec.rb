require 'rails_helper'

RSpec.describe ExcelFile, type: :model do
  describe 'relationship verification' do
    it 'belongs to homework' do
      relationship = ExcelFile.reflect_on_association(:assignment).macro
      expect(relationship).to eql(:belongs_to)
    end
  end
end

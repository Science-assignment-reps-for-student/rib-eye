require 'rails_helper'

RSpec.describe HomeworkFile, type: :model do
  describe 'relationship verification' do
    it 'belongs to homework' do
      relationship = HomeworkFile.reflect_on_association(:homework).macro
      expect(relationship).to eql(:belongs_to)
    end
  end
end

require 'rails_helper'

RSpec.describe SingleFile, type: :model do
  describe 'relationship verification' do
    it 'belongs to homework' do
      relationship = SingleFile.reflect_on_association(:homework).macro
      expect(relationship).to eql(:belongs_to)
    end

    it 'belongs to student' do
      relationship = SingleFile.reflect_on_association(:student).macro
      expect(relationship).to eql(:belongs_to)
    end
  end
end

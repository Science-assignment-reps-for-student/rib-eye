require 'rails_helper'

RSpec.describe PersonalFile, type: :model do
  before(:all) do
    @assignment = create(:assignment, type: 'PERSONAL')
    @student = create(:student)
    @personal_file = create(:personal_file,
                            assignment_id: @assignment.id,
                            student_id: @student.id)
  end

  describe 'relationship verification' do
    it 'belongs to assignment' do
      relationship = PersonalFile.reflect_on_association(:assignment).macro
      expect(relationship).to eql(:belongs_to)
    end

    it 'belongs to student' do
      relationship = PersonalFile.reflect_on_association(:student).macro
      expect(relationship).to eql(:belongs_to)
    end
  end

  describe 'file process' do
    it 'storing file' do
      file_storing_test(@personal_file)
    end
  end
end

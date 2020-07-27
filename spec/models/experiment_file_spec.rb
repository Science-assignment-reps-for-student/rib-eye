require_relative 'model_spec_helper'

RSpec.describe ExperimentFile, type: :model do
  before(:all) do
    @assignment = create(:assignment, type: 'EXPERIMENT')
    @student = create(:student)
    @experiment_file = create(:experiment_file,
                              assignment_id: @assignment.id,
                              student_id: @student.id)
  end

  describe 'relationship verification' do
    it 'belongs to assignment' do
      relationship = ExperimentFile.reflect_on_association(:assignment).macro
      expect(relationship).to eql(:belongs_to)
    end

    it 'belongs to student' do
      relationship = ExperimentFile.reflect_on_association(:student).macro
      expect(relationship).to eql(:belongs_to)
    end
  end

  describe 'file process' do
    it 'storing file' do
      file_storing_test(@experiment_file)
    end
  end
end

require 'rails_helper'

RSpec.describe Assignment, type: :model do
  before(:all) do
    @assignment = create(:assignment)
  end

  describe 'all assignment relationship verification' do
    it 'has many assignment files' do
      relationship = Assignment.reflect_on_association(:assignment_files).macro
      expect(relationship).to eql(:has_many)
    end

    it 'has many single files' do
      relationship = Assignment.reflect_on_association(:personal_files).macro
      expect(relationship).to eql(:has_many)
    end

    it 'has many multi files' do
      relationship = Assignment.reflect_on_association(:team_files).macro
      expect(relationship).to eql(:has_many)
    end

    it 'has many experiment files' do
      relationship = Assignment.reflect_on_association(:experiment_files).macro
      expect(relationship).to eql(:has_many)
    end

    it 'has one excel files' do
      relationship = Assignment.reflect_on_association(:excel_file).macro
      expect(relationship).to eql(:has_one)
    end
  end

  describe 'only team assignment relationship verification' do
    it 'has many teams' do
      relationship = Assignment.reflect_on_association(:teams).macro
      expect(relationship).to eql(:has_many)
    end

    it 'has many self evaluations' do
      relationship = Assignment.reflect_on_association(:self_evaluations).macro
      expect(relationship).to eql(:has_many)
    end

    it 'has many mutual evaluations' do
      relationship = Assignment.reflect_on_association(:mutual_evaluations).macro
      expect(relationship).to eql(:has_many)
    end
  end

  describe 'file compress process' do
    it 'file compress' do
      FileUtils.mkdir_p(@assignment.stored_dir)
      FileUtils.touch(@assignment.compressed_file_path)
      @assignment.generate_compressed_file
      FileUtils.rm_rf(File.dirname(@assignment.stored_dir))
    end
  end
end

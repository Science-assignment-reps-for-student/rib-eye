require 'rails_helper'

RSpec.describe Homework, type: :model do
  describe 'all homework relationship verification' do
    it 'has many homework files' do
      relationship = Homework.reflect_on_association(:homework_files).macro
      expect(relationship).to eql(:has_many)
    end

    it 'has many single files' do
      relationship = Homework.reflect_on_association(:single_files).macro
      expect(relationship).to eql(:has_many)
    end

    it 'has many multi files' do
      relationship = Homework.reflect_on_association(:multi_files).macro
      expect(relationship).to eql(:has_many)
    end

    it 'has many experiment files' do
      relationship = Homework.reflect_on_association(:experiment_files).macro
      expect(relationship).to eql(:has_many)
    end

    it 'has one excel files' do
      relationship = Homework.reflect_on_association(:excel_file).macro
      expect(relationship).to eql(:has_one)
    end
  end

  describe 'only team homework relationship verification' do
    it 'has many teams' do
      relationship = Homework.reflect_on_association(:teams).macro
      expect(relationship).to eql(:has_many)
    end

    it 'has many self evaluations' do
      relationship = Homework.reflect_on_association(:self_evaluations).macro
      expect(relationship).to eql(:has_many)
    end

    it 'has many mutual evaluations' do
      relationship = Homework.reflect_on_association(:mutual_evaluations).macro
      expect(relationship).to eql(:has_many)
    end
  end
end

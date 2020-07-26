require 'rails_helper'

RSpec.describe Student, type: :model do
  describe 'relationship verification' do
    it 'has many assignment files' do
      relationship = Student.reflect_on_association(:personal_files).macro
      expect(relationship).to eql(:has_many)
    end

    it 'has many experiment files' do
      relationship = Student.reflect_on_association(:experiment_files).macro
      expect(relationship).to eql(:has_many)
    end

    it 'has many self evaluations' do
      relationship = Student.reflect_on_association(:self_evaluations).macro
      expect(relationship).to eql(:has_many)
    end

    it 'has many mutual evaluations' do
      relationship = Student.reflect_on_association(:mutual_evaluations).macro
      expect(relationship).to eql(:has_many)
    end
  end
end

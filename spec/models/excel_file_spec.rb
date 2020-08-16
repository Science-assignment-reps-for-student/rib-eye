require 'rails_helper'

RSpec.describe ExcelFile, type: :model do
  describe 'relationship verification' do
    it 'belongs to assignment' do
      relationship = ExcelFile.reflect_on_association(:assignment).macro
      expect(relationship).to eql(:belongs_to)
    end
  end

  describe 'file process' do
    it 'personal assignment excel file' do
      assignment = create(:assignment)
      create(:student)
      assignment.generate_excel_file
    end

    it 'team assignment excel file' do
      assignment = create(:assignment, type: 'TEAM')
      student = create(:student)
      target_student = create(:student, email: 'student2@dsm.hs.kr',
                                        student_number: '1419',
                                        name: '최승교')
      team = create(:team, assignment_id: assignment.id, leader_id: student.id)
      create(:member, team_id: team.id, student_id: student.id)
      create(:member, team_id: team.id, student_id: target_student.id)
      create(:self_evaluation, assignment_id: assignment.id,
                               student_id: student.id)
      create(:mutual_evaluation, assignment_id: assignment.id,
                                 student_id: student.id,
                                 target_id: target_student.id)

      assignment.generate_excel_file
    end
  end
end

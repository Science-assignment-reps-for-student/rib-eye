class Student < ApplicationRecord
  has_many :personal_files, dependent: :delete_all
  has_many :experiment_files, dependent: :delete_all
  has_many :self_evaluations, dependent: :delete_all
  has_many :mutual_evaluations, dependent: :delete_all

  def class_number
    student_number[1]
  end

  def team(assignment_id)
    Assignment.find_by_id(assignment_id).teams.find do |team|
      team.students.find { |student| student.id == id }
    end
  end
end

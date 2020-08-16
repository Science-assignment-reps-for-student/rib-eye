class Student < ApplicationRecord
  has_many :personal_files, dependent: :delete_all
  has_many :experiment_files, dependent: :delete_all
  has_many :self_evaluations, dependent: :delete_all
  has_many :mutual_evaluations, dependent: :delete_all

  def class_number
    student_number[1]
  end
end

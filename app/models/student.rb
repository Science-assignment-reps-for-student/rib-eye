class Student < ApplicationRecord
  has_many :personal_files, dependent: :delete_all
  has_many :self_evaluations, dependent: :delete_all
  has_many :mutual_evaluations, foreign_key: :target_id, dependent: :delete_all
end

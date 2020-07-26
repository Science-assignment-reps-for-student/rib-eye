class Team < ApplicationRecord
  has_many :team_files, dependent: :delete_all
  has_many :members, dependent: :delete_all
  has_many :students, through: :members
  belongs_to :student, foreign_key: :leader_id
end

class Team < ApplicationRecord
  has_many :multi_files, dependent: :delete_all
  has_many :members, dependent: :delete_all
  has_many :students, through: :members
end

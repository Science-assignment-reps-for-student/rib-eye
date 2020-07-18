class Member < ApplicationRecord
  belongs_to :student
  belongs_to :team
end

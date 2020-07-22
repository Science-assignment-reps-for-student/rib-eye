class ExperimentFile < ApplicationRecord
  belongs_to :assignment
  belongs_to :student
end

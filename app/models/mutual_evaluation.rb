class MutualEvaluation < ApplicationRecord
  belongs_to :student, foreign_key: :target_id
end

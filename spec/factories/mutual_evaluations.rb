FactoryBot.define do
  factory :mutual_evaluation do
    communication { 3 }
    cooperation { 3 }
    created_at { DateTime.new(2020) }
  end
end

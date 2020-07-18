FactoryBot.define do
  factory :self_evaluation do
    scientific_accuracy { 3 }
    communication { 3 }
    attitude { 3 }
    created_at { DateTime.new(2020) }
  end
end

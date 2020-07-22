FactoryBot.define do
  factory :assignment do
    title { '제목' }
    description { '설명' }
    type { 'SINGLE' }
    created_at { DateTime.new(2020) }
    deadline_1 { DateTime.new(2020) }
    deadline_2 { DateTime.new(2020) }
    deadline_3 { DateTime.new(2020) }
    deadline_4 { DateTime.new(2020) }
  end
end

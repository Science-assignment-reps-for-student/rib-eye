FactoryBot.define do
  factory :student do
    email { 'student@dsm.hs.kr' }
    password { 'q1w2e3r4' }
    student_number { '1418' }
    name { '정우영' }
  end
end

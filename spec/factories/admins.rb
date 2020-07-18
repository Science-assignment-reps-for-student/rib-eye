FactoryBot.define do
  factory :admin do
    email { 'admin@dsm.hs.kr' }
    password { 'q1w2e3r4' }
    name { '관리자' }
  end
end

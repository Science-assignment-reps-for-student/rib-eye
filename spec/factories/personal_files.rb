FactoryBot.define do
  factory :personal_file do
    file_name { '개인.hwp' }
    path { '/rib-eye/experiment_file/1/개인.hwp' }
    created_at { DateTime.new(2020) }
    is_late { false }
  end
end

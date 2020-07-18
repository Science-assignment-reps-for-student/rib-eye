FactoryBot.define do
  factory :experiment_file do
    file_name { '실험.hwp' }
    path { '/rib-eye/experiment_file/1/실험.hwp' }
    created_at { DateTime.new(2020) }
    is_late { false }
  end
end

FactoryBot.define do
  factory :team_file do
    file_name { '팀.hwp' }
    path { '/rib-eye/experiment_file/1/팀.hwp' }
    created_at { DateTime.new(2020) }
    is_late { false }
  end
end

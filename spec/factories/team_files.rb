FactoryBot.define do
  factory :team_file do
    file_name { '팀.hwp' }
    path do
      path = File.join(ApplicationRecord.stored_dir, 'team_file/1/1/팀.hwp')
      FileUtils.mkdir_p(File.dirname(path))
      FileUtils.touch(path)
      path
    end
    created_at { DateTime.new(2020) }
    is_late { false }
  end
end

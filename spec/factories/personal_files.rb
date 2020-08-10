FactoryBot.define do
  factory :personal_file do
    file_name { '개인.hwp' }
    path do
      path = File.join(ApplicationRecord.stored_dir, 'personal_file/1/1/개인.hwp')
      FileUtils.mkdir_p(File.dirname(path))
      FileUtils.touch(path)
      path
    end
    created_at { DateTime.new(2020) }
    is_late { false }
  end
end

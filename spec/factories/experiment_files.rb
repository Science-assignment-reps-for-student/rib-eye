FactoryBot.define do
  factory :experiment_file do
    file_name { '실험.hwp' }
    path do
      path = File.join(ApplicationRecord.stored_dir, 'experiment_file/1/1/실험.hwp')
      FileUtils.mkdir_p(File.dirname(path))
      FileUtils.touch(path)
      path
    end
    created_at { DateTime.new(2020) }
    is_late { false }
  end
end

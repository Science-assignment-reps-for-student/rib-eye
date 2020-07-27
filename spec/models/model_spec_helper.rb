require 'rails_helper'

def file_storing_test(instance)
  FileUtils.touch(ApplicationRecord.stored_dir + '/.keep')
  file = File.open(ApplicationRecord.stored_dir + '/.keep')

  instance.store_file(file)
  instance.destroy_file

  FileUtils.rm_rf(File.join(ApplicationRecord.stored_dir,
                            "#{instance.assignment.type.downcase}_file"))
  FileUtils.touch(ApplicationRecord.stored_dir + '/.keep')
end

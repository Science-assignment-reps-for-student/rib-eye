require 'rails_helper'

def singular_file_test(instance)
  file = File.open(ApplicationRecord.stored_dir + '/.keep')
  instance.store_singular_file(file)
  FileUtils.mv(instance.stored_dir + instance.singular_file_name(''),
               ApplicationRecord.stored_dir + '/.keep')
  FileUtils.rm_rf("#{ApplicationRecord.stored_dir}"\
                      "/#{instance.assignment.type.downcase}_file")
end

def plural_files_test(instance)
  files = [File.open(ApplicationRecord.stored_dir + '/.keep')]
  instance.store_plural_files(*files)
  files.each do |file|
    FileUtils.mv(instance.stored_dir + File.basename(file),
                 ApplicationRecord.stored_dir + '/.keep')
  end
  FileUtils.rm_rf("#{ApplicationRecord.stored_dir}"\
                      "/#{instance.assignment.type.downcase}_file")
end

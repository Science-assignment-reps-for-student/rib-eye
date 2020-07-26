module FileHelper
  extend ActiveSupport::Concern

  def store_plural_files(*files)
    FileUtils.mkdir_p(stored_dir)
    files.each { |file| store_file(file) }
  end

  def store_singular_file(file)
    FileUtils.mkdir_p(stored_dir)
    store_file(file, singular_file_name(File.extname(file)))
  end

  def store_file(file, file_name = File.basename(file))
    FileUtils.mv(file, stored_dir + file_name)
  end
end
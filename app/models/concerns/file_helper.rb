module FileHelper
  extend ActiveSupport::Concern

  def self.create!(files, **kwargs)
    instance = super kwargs

    if files.length == 1
      instance.store_singular_file(files[0])
    else
      instance.store_plural_files(*files)
    end
  end

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

  def destroy_file
    FileUtils.rm(path)
  end
end
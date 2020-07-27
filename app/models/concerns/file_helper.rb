module FileHelper
  extend ActiveSupport::Concern

  def store_file(file, name = singular_file_name)
    path = File.join(stored_dir, name)

    FileUtils.mkdir_p(stored_dir)
    FileUtils.mv(file, path)

    self.file_name = name
    self.path = path
    save
  end

  def destroy_file
    FileUtils.rm(File.join(stored_dir, file_name))
  end

  def destroy!
    super.destroy_file
  end

  module FileGenerator
    def create!(file, name = singular_file_name, **kwargs)
      super(kwargs).store_file(file, name)
    end
  end
end
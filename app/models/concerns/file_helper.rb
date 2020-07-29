module FileHelper
  extend ActiveSupport::Concern

  def store_file(file, name = singular_file_name(file))
    path = File.join(stored_dir, name)

    FileUtils.mkdir_p(stored_dir)
    FileUtils.mv(file, path)

    self.file_name = name
    self.path = path
    if assignment.send("deadline_#{student.class_number}") > Time.zone.now
      self.is_late = true
    else
      self.is_late = false
    end

    save
  end

  def destroy_file
    FileUtils.rm(File.join(stored_dir, file_name))
  end

  def destroy!
    super.destroy_file
  end

  module FileGenerator
    def create!(file, **kwargs)
      instance = super(kwargs)

      if kwargs[:file_name]
        instance.store_file(file, kwargs[:file_name])
      else
        instance.store_file(file)
      end
    end
  end
end
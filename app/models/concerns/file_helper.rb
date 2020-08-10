module FileHelper
  extend ActiveSupport::Concern

  def store_file(file, name = singular_file_name(file))
    path = File.join(stored_dir, name)

    FileUtils.mkdir_p(stored_dir)
    FileUtils.mv(file, path)

    self.file_name = name
    self.path = path
    late?

    save
  end

  def late?
    deadline = if assignment.type == 'TEAM'
                 assignment.send("deadline_#{team.student.class_number}")
               else
                 assignment.send("deadline_#{student.class_number}")
               end

    self.is_late = deadline > created_at
  end

  def destroy_file
    FileUtils.rm(File.join(stored_dir, file_name))
  end

  def destroy!
    super.destroy_file
  end

  module FileGenerator
    def create!(file, **options)
      instance = super(options)

      if options[:file_name]
        instance.store_file(file, options[:file_name])
      else
        instance.store_file(file)
      end
    end
  end
end
module FileHelper
  extend ActiveSupport::Concern

  module FileGenerator
    def create_with_file!(files, is_initial_submission, **options)
      if files.length == 1 && is_initial_submission
        create!(files[0], **options).late?
      else
        files.map do |file|
          create!(file, **options, file_name: File.basename(file))
        end.each(&:late?)
      end
    end

    def create!(file, **options)
      super(options).store_file(file)
    end
  end

  def store_file(file)
    self.file_name ||= singular_file_name(file)
    self.path = File.join(stored_dir, file_name)
    save

    FileUtils.mkdir_p(stored_dir)
    FileUtils.mv(file, path)

    self
  end

  def late?
    deadline = if assignment.type == 'TEAM'
                 assignment.send("deadline_#{team.student.class_number}")
               else
                 assignment.send("deadline_#{student.class_number}")
               end

    self.is_late = deadline > created_at
    save
  end

  def destroy!
    super.destroy_file
  end

  def destroy_file
    FileUtils.rm(File.join(stored_dir, file_name))
  end
end
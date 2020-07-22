class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  self.pluralize_table_names = false

  EXTNAME_WHITELIST = %i[.hwp .jpg .png .jpeg .pptx .word .pdf .zip].freeze

  def store_plural_files(*files)
    FileUtils.mkdir(stored_dir)
    files.each { |file| store_file(file) }
  end

  def store_singular_file(file)
    FileUtils.mkdir(stored_dir)
    store_file(file, singular_file_name(File.extname(file)))
  end

  def store_file(file, file_name = File.basename(file))
    FileUtils.mv(file, stored_dir + file_name)
  end

  def stored_dir
    File.dirname(File.dirname(__dir__)) + '/storage'
  end
end

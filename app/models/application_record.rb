class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  self.pluralize_table_names = false

  EXTNAME_WHITELIST = %w[.hwp .jpg .png .jpeg .pptx .word .pdf .zip].freeze

  def stored_dir
    ApplicationRecord.stored_dir
  end

  def self.stored_dir
    File.join(File.dirname(File.dirname(__dir__)), 'storage')
  end
end

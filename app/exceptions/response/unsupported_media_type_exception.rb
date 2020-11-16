# frozen_string_literal: true

require './app/exceptions/exception_core'

module UnsupportedMediaTypeException
  EXTNAME_WHITELIST = %w[.hwp .jpg .png .jpeg .pptx .word .pdf .zip .mp4 .avi].freeze

  class UnsupportedMediaType < ExceptionCore
    attr_reader :should_raise, :status

    def initialize(files)
      @status = :unsupported_media_type

      BadRequestException::BadFileType.except(files)

      invalid_files = files.each_with_object([]) do |file, obj|
        obj << file unless EXTNAME_WHITELIST.include?(File.extname(file).downcase)
      end

      @should_raise = !invalid_files.blank?

      super("Unsupported Media Type : #{invalid_files.map(&:original_filename)}")
    end

    def self.except(files)
      super(new(files))
    end
  end
end

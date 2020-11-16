# frozen_string_literal: true

require './app/exceptions/exception_core'

module ConflictException
  class Conflict < ExceptionCore
    attr_reader :should_raise, :status

    def initialize(files:, existing_files:)
      conflict_files = (files & existing_files)
      super("Conflict : #{conflict_files.map(&:file_name)}")
    end

    def self.except(files:, existing_files:)
      super(new(files: files, existing_files: existing_files))
    end
  end
end
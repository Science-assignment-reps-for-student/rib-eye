# frozen_string_literal: true

require './app/exceptions/exception_core'

module ConflictException
  class Conflict < ExceptionCore
    attr_reader :should_raise, :status

    def initialize(files:, existing_files:)
      conflict_files = (files.map { |f| File.basename(f.path) } & existing_files.map(&:file_name))
      super("Conflict : #{conflict_files}")
    end

    def self.except(files:, existing_files:)
      super(new(files: files, existing_files: existing_files))
    end
  end
end
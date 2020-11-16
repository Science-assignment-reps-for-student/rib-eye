# frozen_string_literal: true

require './app/exceptions/exception_core'

module NotFoundException
  class NotFound < ExceptionCore
    attr_reader :should_raise, :status

    def initialize(**params)
      @status = :not_found

      invalid_params = params.filter { |_, value| value.nil? }.keys
      @should_raise = !invalid_params.blank?

      super("Not found : #{invalid_params}")
    end

    def self.except(**params)
      super(new(params))
    end
  end
end

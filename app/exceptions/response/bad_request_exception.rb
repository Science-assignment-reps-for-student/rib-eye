# frozen_string_literal: true

require './app/exceptions/exception_core'

module BadRequestException
  class BadAssignmentName < ExceptionCore
    attr_reader :should_raise, :status

    def initialize(title)
      @status = :bad_request

      @should_raise = title.include?('/')

      super('Bad Request : invalid assignment name')
    end

    def self.except(assignment)
      super(new(assignment))
    end
  end

  class BadAssignmentType < ExceptionCore
    attr_reader :should_raise, :status

    def initialize(type)
      @status = :bad_request

      @should_raise = !Assignment.types.keys.include?(type)

      super('Bad Request : invalid type')
    end

    def self.except(type)
      super(new(type))
    end
  end

  class BadFileType < ExceptionCore
    attr_reader :should_raise, :status

    def initialize(files)
      @status = :bad_request

      @should_raise = files.class != Array
      super('Bad Request : file must be array')
    end

    def self.except(files)
      super(new(files))
    end
  end
end
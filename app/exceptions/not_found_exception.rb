module NotFoundException
  class NotFound < KeyError
    attr_reader :should_raise, :status

    def initialize(**params)
      @status = :not_found

      invalid_params = params.filter { |_, value| value.nil? }.keys
      @should_raise = !invalid_params.blank?
      super("Not found : #{invalid_params}")
    end
  end
end

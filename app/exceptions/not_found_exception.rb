module NotFoundException
  class NotFound < KeyError
    attr_reader :should_raise

    def initialize(**params)
      invalid_params = params.filter { |_, value| value.nil? }.keys
      @should_raise = !invalid_params.blank?
      super("Not found : #{invalid_params}")
    end
  end

  def not_found(error)
    render json: { error_message: error.message },
           status: :not_found
    raise error
  end
end

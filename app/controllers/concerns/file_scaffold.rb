module FileScaffold
  extend ActiveSupport::Concern

  module HelperMethod
    def file_input_stream
      params.require(:file)

      @files = params[:file].map do |file|
        unless ApplicationRecord::EXTNAME_WHITELIST.include?(File.extname(file).downcase)
          return render status: :unsupported_media_type
        end

        File.open(file)
      end
    end
  end

  module ControllerMethod
    def show
      file = yield
      return render status: :not_found unless file

      send_file(file.path,
                filename: file.file_name,
                status: :no_content)
    end

    def index
      status = yield

      render status: :ok,
             json: status.ids
    end

    def create(model, conflict_condition, **options)
      return render status: :conflict if conflict_condition.call

      if @files.length == 1
        model.create!(@files[0], **options)
      else
        @files.each do |file|
          model.create!(file, **options, file_name: File.basename(file))
        end
      end

      render status: :created
    end

    def destroy
      submit_file = yield
      return render status: :precondition_failed if submit_file.empty?

      submit_file.each(&:destroy!)

      render status: :ok
    end
  end
end

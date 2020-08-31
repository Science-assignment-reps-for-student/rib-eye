module FileScaffold
  extend ActiveSupport::Concern

  module HelperMethod
    def file_input_stream
      @files = params[:file]&.map do |file|
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
                filename: file.file_name)
    end

    def index
      file_information = yield.map do |file|
        {
          file_name: file.file_name,
          file_id: file.id
        }
      end

      render status: :ok,
             json: { file_information: file_information }
    end

    def create(model, conflict_condition, **options)
      params.require(:file)

      return render status: :conflict if conflict_condition.call

      model.create_with_file!(@files, **options)

      NoticeMailer.submission(@student, @assignment).deliver_later

      render status: :created
    end

    def destroy(model)
      params.require(:file_id)

      submit_file = model.find_by_id(params[:file_id])
      return render status: :not_found unless submit_file

      submit_file.destroy!

      render status: :ok
    end
  end
end

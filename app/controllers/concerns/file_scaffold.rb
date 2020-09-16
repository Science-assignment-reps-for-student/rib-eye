module FileScaffold
  extend ActiveSupport::Concern

  module HelperMethod
    def file_input_stream
      params.require(:file)
      return render status: :bad_request unless params[:file].class == Array

      @files = params[:file].map do |file|
        unless ApplicationRecord::EXTNAME_WHITELIST.include?(File.extname(file).downcase)
          return render status: :unsupported_media_type
        end

        File.rename(file, "#{File.dirname(file)}/#{file.original_filename}")
        File.open("#{File.dirname(file)}/#{file.original_filename}")
      end
    end
  end

  module ControllerMethod
    def show
      file = yield
      return render status: :not_found unless file

      response.headers['Content-Length'] = File.size(file.path)
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

    def create(model, **options)
      params.require(:file)

      submitted_assignments = if model.name == 'TeamFile'
                                model.where(team: @team, assignment: @assignment)
                              else
                                model.where(student: @student, assignment: @assignment)
                              end
      conflict_files = @files.map do |file|
        if submitted_assignments.find_by_file_name(File.basename(file))
          File.basename(file)
        end
      end.compact

      unless conflict_files.blank?
        return render status: :conflict,
                      json: { conflict_files: conflict_files }
      end

      model.create_with_file!(@files, submitted_assignments.blank?, **options)

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

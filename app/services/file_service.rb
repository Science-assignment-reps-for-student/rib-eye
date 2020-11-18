module FileService
  def file_filter(files)
    UnsupportedMediaTypeException::UnsupportedMediaType.except(files)

    @files = files.map do |file|
      File.rename(file, "#{File.dirname(file)}/#{file.original_filename}")
      f = File.open("#{File.dirname(file)}/#{file.original_filename}")
      f.close
      f
    end
  end
end
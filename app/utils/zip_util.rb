require 'zip'

class ZipUtil
  def initialize(assignment)
    @assignment = assignment
  end

  def generate_compressed_file
    FileUtils.rm_f(@assignment.compressed_file_path)
    FileUtils.mkdir_p(File.dirname(@assignment.compressed_file_path))

    Zip::File.open(@assignment.compressed_file_path, Zip::File::CREATE) do |zip|
      search_directory_recursively(@assignment.stored_dir).each do |path|
        zip.add(File.basename(path), path)
      end
    end
    File.open(@assignment.compressed_file_path)
  end

  def search_directory_recursively(directory)
    Dir.glob("#{directory}/*").map do |path|
      if File.directory?(path)
        search_directory_recursively(path)
      else
        path
      end
    end.flatten
  end
end
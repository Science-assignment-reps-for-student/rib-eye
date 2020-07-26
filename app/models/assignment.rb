require 'zip'

class Assignment < ApplicationRecord
  self.inheritance_column = :_type_disabled

  has_many :assignment_files, dependent: :delete_all
  has_many :personal_files, dependent: :delete_all
  has_many :team_files, dependent: :delete_all
  has_many :experiment_files, dependent: :delete_all
  has_one :excel_file, dependent: :delete

  has_many :teams, dependent: :delete_all
  has_many :self_evaluations, dependent: :delete_all
  has_many :mutual_evaluations, dependent: :delete_all

  enum type: { PERSONAL: 'PERSONAL', TEAM: 'TEAM', EXPERIMENT: 'EXPERIMENT' }

  def create_compressed_file
    directory = "#{ApplicationRecord.stored_dir}/#{type.downcase}_file/#{id}"

    Zip::File.open("#{directory}/'[#{type_korean}]#{title}.zip'", Zip::File::CREATE) do |zip|
      search_directory_recursively(directory).each do |path|
        zip.add(File.basename(path), path)
      end
    end
  end

  def type_korean
    if type == 'PERSONAL'
      '개인'
    elsif type == 'TEAM'
      '팀'
    elsif type == 'EXPERIMENT'
      '실험'
    end
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

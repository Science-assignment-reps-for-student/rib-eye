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

  def stored_dir
    File.join(super, "#{type.downcase}_file/#{id}")
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

  def files
    send("#{type.downcase}_files")
  end

  def compressed_file_path
    File.join(stored_dir, compressed_file_name)
  end

  def compressed_file_name
    "[#{type_korean}]#{title}.zip"
  end
end

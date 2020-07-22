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

  enum type: { SINGLE: 'SINGLE', MULTI: 'MULTI', EXPERIMENT: 'EXPERIMENT' }

  def type_korean
    if type == 'SINGLE'
      '개인'
    elsif type == 'MULTI'
      '팀'
    elsif type == 'EXPERIMENT'
      '실험'
    end
  end
end

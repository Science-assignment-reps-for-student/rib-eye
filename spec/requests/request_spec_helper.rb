require 'rails_helper'
require 'jwt_base'

JWT_BASE = JWTBase.new(ENV['SECRET_KEY_BASE'], 1.days, 2.weeks).freeze
URL_PREFIX = '/rib-eye'.freeze

def request(method, url, params = false, headers = true)
  parameters = {}

  parameters[:params] = params if params

  if headers == true
    parameters[:headers] = { Authorization: "Bearer #{@admin_token}" }
  elsif headers
    parameters[:headers] = { Authorization: "Bearer #{headers}" }
  end

  send(method, url, parameters)
end

def set_database(assignment_type)
  student
  admin

  @assignment = create(:assignment, type: assignment_type)

  if assignment_type == 'TEAM'
    team_file
  elsif assignment_type == 'PERSONAL'
    personal_file
  else
    experiment_file
  end
end

def team_file
  @team = create(:team, assignment_id: @assignment.id, leader_id: @student.id)
  create(:member, team_id: @team.id, student_id: @student.id)
  @file = create(:team_file,
                 team_id: @team.id,
                 assignment_id: @assignment.id)
end

def personal_file
  @file = create(:personal_file,
                 student_id: @student.id,
                 assignment_id: @assignment.id)
end

def experiment_file
  @file = create(:experiment_file,
                 student_id: @student.id,
                 assignment_id: @assignment.id)
end

def student
  @student = create(:student)
  @student_token = JWT_BASE.create_access_token(sub: @student.email)
end

def admin
  @admin = create(:admin)
  @admin_token = JWT_BASE.create_access_token(sub: @admin.email)
end

def clean_dummy_file(assignment_type)
  FileUtils.rm_rf File.join(ApplicationRecord.stored_dir,
                            "#{assignment_type.downcase}_file")
  FileUtils.rm_rf(File.join(ApplicationRecord.stored_dir, 'test.hwp'))
  FileUtils.rm_rf(File.join(ApplicationRecord.stored_dir, 'test.unable'))
end
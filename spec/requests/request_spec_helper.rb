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
  @student = create(:student)
  @admin = create(:admin)

  @student_token = JWT_BASE.create_access_token(sub: @student.email)
  @admin_token = JWT_BASE.create_access_token(sub: @admin.email)

  @assignment = create(:assignment, type: assignment_type)

  @file = create("#{assignment_type.downcase}_file",
                 student_id: @student.id,
                 assignment_id: @assignment.id)
end

def clean_dummy_file(assignment_type)
  FileUtils.rm_rf File.join(ApplicationRecord.stored_dir,
                            "#{assignment_type.downcase}_file")
  FileUtils.rm_rf(File.join(ApplicationRecord.stored_dir, 'test.hwp'))
  FileUtils.rm_rf(File.join(ApplicationRecord.stored_dir, 'test.unable'))
end
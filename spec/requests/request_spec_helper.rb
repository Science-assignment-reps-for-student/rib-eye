require 'rails_helper'
require 'jwt_base'

JWT_BASE = JWTBase.new(ENV['SECRET_KEY_BASE'], 1.days, 2.weeks).freeze
URL_PREFIX = '/rib-eye'.freeze

def request(method, url, params = false, headers = false)
  parameters = {}

  parameters[:params] = params if params

  if headers == true
    parameters[:headers] = { Authorization: "Bearer #{@token}" }
  elsif headers
    parameters[:headers] = { Authorization: "Bearer #{headers}" }
  end

  send(method, url, parameters)
end

def set_database(assignment_type)
  @student = create(:student)
  @admin = create(:admin)
  @token = JWT_BASE.create_access_token(sub: @admin.email)

  @assignment = create(:assignment, type: assignment_type)
  @file = create("#{assignment_type.downcase}_file",
                 student_id: @student.id,
                 assignment_id: @assignment.id)
end
require 'rails_helper'
require 'jwt_base'

JWT_BASE = JWTBase.new(ENV['SECRET_KEY_BASE'], 1.days, 2.weeks).freeze
URL_PREFIX = '/rib-eye'.freeze

def request(method, url, params = false, headers = false)
  parameters = {}

  parameters[:params] = params if params

  if headers == true
    parameters[:headers] = { Authorization: "Bearer #{@token}" }
  elsif params
    parameters[:headers] = { Authorization: "Bearer #{headers}" }
  end

  send(method, url, parameters)
end
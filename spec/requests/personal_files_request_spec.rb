require_relative 'request_spec_helper'

RSpec.describe 'PersonalFiles', type: :request do
  before(:all) do
    set_database('PERSONAL')

    @url_personal_file = URL_PREFIX + '/personal-file'
    @url_personal_files = @url_personal_file + 's'
  end

  after(:all) do
    clean_dummy_file('PERSONAL')
  end

  describe 'GET#show' do
    it 'OK' do
      request('get', @url_personal_file, { student_id: @student.id,
                                           assignment_id: @assignment.id }, true)
      expect(response.status).to equal(204)
    end

    it 'Unauthorized' do
      request('get',
              @url_personal_file,
              { student_id: @student.id, assignment_id: @assignment.id },
              false)
      expect(response.status).to equal(401)
    end

    it 'Forbidden' do
      request('get',
              @url_personal_file,
              { student_id: @student.id, assignment_id: @assignment.id },
              JWT_BASE.create_refresh_token(sub: @student.email))
      expect(response.status).to equal(403)
    end

    it 'Not Found student id' do
      request('get',
              @url_personal_file,
              { student_id: @student.id + 1, assignment_id: @assignment.id },
              true)
      expect(response.status).to equal(404)
    end

    it 'Not Found assignment id' do
      request('get',
              @url_personal_file,
              { student_id: @student.id, assignment_id: @assignment.id + 1 },
              true)
      expect(response.status).to equal(404)
    end
  end

  describe 'GET#index' do
    it 'OK' do
      request('get', @url_personal_files + "/#{@assignment.id}", false, true)
      expect(response.status).to equal(204)
    end

    it 'Unauthorized' do
      request('get', @url_personal_files + "/#{@assignment.id}", false, false)
      expect(response.status).to equal(401)
    end

    it 'Forbidden' do
      request('get',
              @url_personal_files + "/#{@assignment.id}",
              false,
              JWT_BASE.create_refresh_token(sub: @student.email))
      expect(response.status).to equal(403)
    end

    it 'Not Found assignment id' do
      request('get',
              @url_personal_files + "/#{@assignment.id + 1}",
              false,
              true)
      expect(response.status).to equal(404)
    end
  end

  describe 'POST#create' do

  end

  describe 'DELETE#destroy' do

  end
end

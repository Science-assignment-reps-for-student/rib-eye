require_relative 'request_spec_helper'

RSpec.describe 'TeamFiles', type: :request do
  before(:all) do
    set_database('TEAM')

    @url_team_file = URL_PREFIX + '/team-file'
    @url_team_files = @url_team_file + 's'
  end

  after(:all) do
    clean_dummy_file('team')
  end

  describe 'GET#show' do
    it 'OK' do
      request('get', "#{@url_team_file}/1", false, true)
      expect(response.status).to equal(204)
    end

    it 'Not Found' do
      request('get', "#{@url_team_file}/2", false, true)
      expect(response.status).to equal(404)
    end
  end

  describe 'GET#index' do
    it 'OK' do
      request('get',
              @url_team_file,
              { team_id: @team.id, assignment_id: @assignment.id },
              true)
      expect(JSON.parse(response.body)).to eql([1])
      expect(response.status).to equal(200)
    end

    it 'Not Found Team' do
      request('get',
              @url_team_file,
              { team_id: @team.id + 1, assignment_id: @assignment.id },
              true)
      expect(response.status).to equal(404)
    end

    it 'Not Found Assignment' do
      request('get',
              @url_team_file,
              { team_id: @team.id, assignment_id: @assignment.id + 1 },
              true)
      expect(response.status).to equal(404)
    end
  end

  describe 'POST#create' do
    it 'Created' do
      @file.destroy!

      request('post',
              @url_team_file + "/#{@assignment.id}",
              { file: FileUtils.touch(ApplicationRecord.stored_dir + '/test.hwp') },
              @student_token)
      expect(response.status).to equal(201)
    end

    it 'Not Found assignment id' do
      request('post',
              @url_team_file + "/#{@assignment.id + 1}",
              { file: FileUtils.touch(ApplicationRecord.stored_dir + '/test.hwp') },
              @student_token)
      expect(response.status).to equal(404)
    end

    it 'Conflict' do
      request('post',
              @url_team_file + "/#{@assignment.id}",
              { file: FileUtils.touch(ApplicationRecord.stored_dir + '/test.hwp') },
              @student_token)
      expect(response.status).to equal(409)
    end

    it 'Unsupported Media Type' do
      request('post',
              @url_team_file + "/#{@assignment.id + 1}",
              { file: FileUtils.touch(ApplicationRecord.stored_dir + '/test.unable') },
              @student_token)
      expect(response.status).to equal(415)
    end
  end

  describe 'DELETE#destroy' do
    it 'OK' do
      FileUtils.touch(ApplicationRecord.stored_dir + '/team_file/1/1/팀.hwp')

      request('delete',
              @url_team_file + "/#{@assignment.id}",
              false,
              @student_token)
      expect(response.status).to equal(200)
    end

    it 'Not Found assignment id' do
      request('delete',
              @url_team_file + "/#{@assignment.id + 1}",
              false,
              @student_token)
      expect(response.status).to equal(404)
    end
  end
end

require_relative 'request_spec_helper'

RSpec.describe 'ExperimentFiles', type: :request do
  before(:all) do
    set_database('EXPERIMENT')

    @url_experiment_file = URL_PREFIX + '/experiment-file'
    @url_experiment_files = @url_experiment_file + 's'
  end

  after(:all) do
    clean_dummy_file('EXPERIMENT')
  end

  describe 'GET#show' do
    it 'OK' do
      request('get', "#{@url_experiment_file}/1", false, true)
      expect(response.status).to equal(204)
    end

    it 'Not Found' do
      request('get', "#{@url_experiment_file}/2", false, true)
      expect(response.status).to equal(404)
    end
  end

  describe 'GET#index' do
    it 'OK' do
      request('get',
              @url_experiment_files + "/#{@assignment.id}",
              false,
              @student_token)
      expect(JSON.parse(response.body, symbolize_names: true)).to(eql([{ file_id: @file.id,
                                                                         file_name: @file.file_name }]))
      expect(response.status).to equal(200)
    end

    it 'Not Found Assignment' do
      request('get',
              @url_experiment_files + "/#{@assignment.id + 1}",
              false,
              @student_token)
      expect(response.status).to equal(404)
    end
  end

  describe 'POST#create' do
    it 'Created' do
      @file.destroy!

      request('post',
              @url_experiment_file + "/#{@assignment.id}",
              { file: FileUtils.touch(ApplicationRecord.stored_dir + '/test.hwp') },
              @student_token)
      expect(response.status).to equal(201)
    end

    it 'Not Found assignment id' do
      request('post',
              @url_experiment_file + "/#{@assignment.id + 1}",
              { file: FileUtils.touch(ApplicationRecord.stored_dir + '/test.hwp') },
              @student_token)
      expect(response.status).to equal(404)
    end

    it 'Conflict' do
      request('post',
              @url_experiment_file + "/#{@assignment.id}",
              { file: FileUtils.touch(ApplicationRecord.stored_dir + '/test.hwp') },
              @student_token)
      expect(response.status).to equal(409)
    end

    it 'Unsupported Media Type' do
      request('post',
              @url_experiment_file + "/#{@assignment.id + 1}",
              { file: FileUtils.touch(ApplicationRecord.stored_dir + '/test.unable') },
              @student_token)
      expect(response.status).to equal(415)
    end
  end

  describe 'DELETE#destroy' do
    it 'OK' do
      FileUtils.touch(ApplicationRecord.stored_dir + '/experiment_file/1/1/실험.hwp')

      request('delete',
              @url_experiment_file + "/#{@file.id}",
              false,
              @student_token)
      expect(response.status).to equal(200)
    end

    it 'Not Found assignment id' do
      request('delete',
              @url_experiment_file + "/#{@file.id + 1}",
              false,
              @student_token)
      expect(response.status).to equal(404)
    end
  end
end

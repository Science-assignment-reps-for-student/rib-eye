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
      request('get', "#{@url_personal_file}/1", false, true)
      expect(response.status).to equal(200)
    end

    it 'Not Found' do
      request('get', "#{@url_personal_file}/2", false, true)
      expect(response.status).to equal(404)
    end
  end

  describe 'GET#status_for_admin' do
    it 'OK' do
      request('get',
              @url_personal_files + "/#{@assignment.id}",
              { student_id: @student.id },
              true)
      expect(JSON.parse(response.body, symbolize_names: true))
        .to(eql(file_information: [{ file_id: @file.id, file_name: @file.file_name }]))
      expect(response.status).to equal(200)
    end

    it 'Not Found Assignment' do
      request('get',
              @url_personal_files + "/#{@assignment.id + 1}",
              false,
              true)
      expect(response.status).to equal(404)
    end
  end

  describe 'GET#status_for_student' do
    it 'OK' do
      request('get',
              @url_personal_file + "/status/#{@assignment.id}",
              false,
              @student_token)
      expect(JSON.parse(response.body, symbolize_names: true))
        .to(eql(file_information: [{ file_id: @file.id, file_name: @file.file_name }]))
      expect(response.status).to equal(200)
    end

    it 'Not Found Assignment' do
      request('get',
              @url_personal_file + "/status/#{@assignment.id + 1}",
              false,
              @student_token)
      expect(response.status).to equal(404)
    end
  end

  describe 'POST#create' do
    it 'Created' do
      @file.destroy!

      request('post',
              @url_personal_file + "/#{@assignment.id}",
              { file: [form_data(FileUtils.touch(ApplicationRecord.stored_dir + '/test.hwp')[0])] },
              @student_token)
      expect(response.status).to equal(201)
    end

    it 'Not Found assignment id' do
      request('post',
              @url_personal_file + "/#{@assignment.id + 1}",
              { file: [form_data(FileUtils.touch(ApplicationRecord.stored_dir + '/test.hwp')[0])] },
              @student_token)
      expect(response.status).to equal(404)
    end

    it 'Unsupported Media Type' do
      request('post',
              @url_personal_file + "/#{@assignment.id + 1}",
              { file: FileUtils.touch(ApplicationRecord.stored_dir + '/test.unable') },
              @student_token)
      expect(response.status).to equal(415)
    end
  end

  describe 'DELETE#destroy' do
    it 'OK' do
      FileUtils.touch(ApplicationRecord.stored_dir + '/personal_file/1/1/개인.hwp')

      request('delete',
              @url_personal_file + "/#{@file.id}",
              false,
              @student_token)
      expect(response.status).to equal(200)
    end

    it 'Not Found assignment id' do
      request('delete',
              @url_personal_file + "/#{@file.id + 1}",
              false,
              @student_token)
      expect(response.status).to equal(404)
    end
  end
end

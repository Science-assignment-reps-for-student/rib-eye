require 'rails_helper'

RSpec.describe "AssignmentFiles", type: :request do
  before(:all) do
    admin
    student

    @assignment = create(:assignment)
    @file = create(:assignment_file,
                   assignment_id: @assignment.id,
                   path: ApplicationRecord.stored_dir + '/assignment_file/1/1/양식.hwp')

    FileUtils.mkdir_p(File.dirname(@file.path))
    FileUtils.touch(@file.path)

    @url_assignment_file = URL_PREFIX + '/assignment-file'
    @url_assignment_files = @url_assignment_file + 's'
  end

  after(:all) do
    clean_dummy_file('ASSIGNMENT')
  end

  describe 'GET#show' do
    it 'OK' do
      request('get', "#{@url_assignment_file}/#{@assignment.id}", false, @student_token)
      expect(response.status).to equal(200)
    end

    it 'Not Found' do
      request('get', "#{@url_assignment_file}/#{@assignment.id + 1}", false, @student_token)
      expect(response.status).to equal(404)
    end
  end

  describe 'GET#index' do
    it 'OK' do
      request('get',
              @url_assignment_files + "/#{@assignment.id}",
              false,
              @student_token)
      expect(JSON.parse(response.body, symbolize_names: true)).to(eql([{ file_id: @file.id,
                                                                         file_name: @file.file_name }]))
      expect(response.status).to equal(200)
    end

    it 'Not Found Assignment' do
      request('get',
              @url_assignment_files + "/#{@assignment.id + 1}",
              false,
              @student_token)
      expect(response.status).to equal(404)
    end
  end

  describe 'DELETE#destroy' do
    it 'OK' do
      request('delete',
              @url_assignment_file + "/#{@file.id}",
              false,
              true)
      expect(response.status).to equal(200)
    end

    it 'Not Found assignment id' do
      request('delete',
              @url_assignment_file + "/#{@file.id + 1}",
              false,
              true)
      expect(response.status).to equal(404)
    end
  end
end

require_relative 'request_spec_helper'

RSpec.describe 'ExcelFiles', type: :request do
  before(:all) do
    set_database('TEAM')

    @url_excel_file = URL_PREFIX + '/excel-file'
    @url_excel_files = @url_excel_file + 's'
  end

  after(:all) do
    FileUtils.rm_rf(ApplicationRecord.stored_dir + '/excel_file')
  end

  describe 'GET#show' do
    it 'OK' do
      @assignment.generate_excel_file

      request('get', "#{@url_excel_file}/1", false, true)
      expect(response.status).to eql(200)
    end

    it 'Not Found' do
      request('get', "#{@url_excel_file}/2", false, true)
      expect(response.status).to eql(404)
    end
  end

  describe 'PATCH#update' do
    it 'OK' do
      request('patch', "#{@url_excel_file}/1", false, true)
      expect(response.status).to eql(200)
    end

    it 'Not Found' do
      request('patch', "#{@url_excel_file}/2", false, true)
      expect(response.status).to eql(404)
    end
  end
end

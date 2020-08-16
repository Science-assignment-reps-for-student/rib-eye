require_relative 'request_spec_helper'

RSpec.describe 'Assignments', type: :request do
  before(:all) do
    set_database('PERSONAL')

    @url_assignment = URL_PREFIX + '/assignment'
    @url_assignments = @url_assignment + 's'
  end

  describe 'GET#show' do
    it 'OK' do
      request('get', "#{@url_assignment}/#{@assignment.id}", false, true)
      expect(response.status).to equal(204)
    end

    it 'Not Found' do
      request('get', "#{@url_assignment}/#{@assignment.id + 1}", false, true)
      expect(response.status).to equal(404)
    end
  end

  describe 'GET#index' do
    it 'Get Personal File' do
      request('get',
              "#{@url_assignments}/#{@assignment.id}",
              { student_id: @student.id },
              true)
      expect(response.status).to equal(200)
      expect(JSON.parse(response.body, symbolize_names: true))
        .to(eql([{ file_id: @file.id, file_name: @file.file_name }]))
    end

    it 'Get Team File' do
      @assignment = create(:assignment, type: 'TEAM')
      team_file

      request('get',
              "#{@url_assignments}/#{@assignment.id}",
              { team_id: @team.id },
              true)

      expect(response.status).to equal(200)
      expect(JSON.parse(response.body, symbolize_names: true))
        .to(eql([{ file_id: @file.id, file_name: @file.file_name }]))
    end

    it 'Not Found' do
      request('get',
              "#{@url_assignments}/#{@assignment.id + 1}",
              { student_id: @student.id },
              true)
      expect(response.status).to equal(404)
    end
  end

  describe 'POST#create' do
    it 'OK' do
      request('post',
              @url_assignment,
              { file: FileUtils.touch(ApplicationRecord.stored_dir + '/test.hwp'),
                title: 'title',
                description: 'description',
                type: 'PERSONAL',
                deadline_1: DateTime.new(2020),
                deadline_2: DateTime.new(2020),
                deadline_3: DateTime.new(2020),
                deadline_4: DateTime.new(2020) }, true)
      expect(response.status).to equal(201)

      FileUtils.rm_rf(ApplicationRecord.stored_dir + '/assignment_file')
    end
  end

  describe 'PATCH#update' do
    it 'OK' do
      request('patch',
              @url_assignment + "/#{@assignment.id}",
              { title: 'title',
                description: 'description',
                type: 'TEAM',
                deadline_1: DateTime.new(2020),
                deadline_2: DateTime.new(2020),
                deadline_3: DateTime.new(2020),
                deadline_4: DateTime.new(2020) }, true)
      expect(response.status).to equal(200)
    end

    it 'Not Found' do
      request('patch',
              @url_assignment + "/#{@assignment.id + 1}",
              { title: 'title',
                description: 'description',
                type: 'TEAM',
                deadline_1: DateTime.new(2020),
                deadline_2: DateTime.new(2020),
                deadline_3: DateTime.new(2020),
                deadline_4: DateTime.new(2020) }, true)
      expect(response.status).to equal(404)
    end
  end

  describe 'DELETE#destroy' do
    it 'OK' do
      request('delete', @url_assignment + "/#{@assignment.id}", false, true)
      expect(response.status).to equal(200)
    end

    it 'Not Found' do
      request('delete', @url_assignment + "/#{@assignment.id + 1}", false, true)
      expect(response.status).to equal(404)
    end
  end
end

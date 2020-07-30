require_relative 'request_spec_helper'

RSpec.describe 'PersonalFiles', type: :request do
  before(:all) do
    set_database('PERSONAL')

    @url_personal_file = URL_PREFIX + '/personal-file'
    @url_personal_files = @url_personal_file + 's'
  end

  describe 'GET#show' do

  end

  describe 'GET#index' do

  end

  describe 'POST#create' do

  end

  describe 'DELETE#destroy' do

  end
end

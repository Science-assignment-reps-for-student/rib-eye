require './app/exceptions/response'
require './app/services/file_service'

class ApplicationController < ActionController::API
  include Response
  include FileService

  rescue_from 'UnauthorizedException::Unauthorized',
              'ForbiddenException::Forbidden',
              'NotFoundException::NotFound',
              'UnsupportedMediaTypeException::UnsupportedMediaType',
              'BadRequestException::BadAssignmentName',
              'BadRequestException::BadAssignmentType',
              'BadRequestException::BadFileType' do |e|
    render_error(e)
  end

  before_action do
    @payload = ForbiddenException::Forbidden.except(request.authorization).payload
  end

  protected

  def file_filter
    return nil if params[:file].nil?

    super(params[:file])
  end

  private

  def render_error(error)
    render json: { error_message: error.message },
           status: error.status
  end
end

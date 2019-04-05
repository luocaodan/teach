require 'uuidtools'

class UploadsController < ApplicationController
  def index
    project_id = params[:project_id]
    filename = params[:image].original_filename
    data = params[:image].read
    filename = "#{::UUIDTools::UUID.timestamp_create.to_s.delete('-')}_#{filename}"
    Dir.mkdir 'tmp' unless File.directory?('tmp')
    tmp_file = File.new "tmp/#{filename}", 'wb+'
    tmp_file.syswrite data
    tmp_file.seek(0)
    res = uploads_service.upload_projects_file project_id, tmp_file
    File.delete tmp_file.path

    respond_to do |format|
      format.json do
        render json: res
      end
    end
  end

  def upload_url
    project_id = params[:project_id]
    project = admin_api_get "projects/#{project_id}"
    respond_to do |format|
      format.json do
        render json: {web_url: project['web_url']}
      end
    end
  end

  private

  def uploads_service
    ::UploadsService.new current_user
  end
end
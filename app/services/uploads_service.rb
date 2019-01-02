class UploadsService < BaseService
  def upload_projects_file(project_id, data)
    multipart_post "projects/#{project_id}/uploads", file: data
  end
end
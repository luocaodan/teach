class ProjectsController < ApplicationController
  def labels
    respond_to do |format|
      format.json do
        labels = project_service.all_labels project_id
        render json: labels
      end
    end
  end

  def members
    respond_to do |format|
      format.json do
        members = project_service.all_members project_id
        render json: members
      end
    end
  end

  def project_id
    params[:project_id]
  end

  def project_service
    ProjectsService.new current_user
  end
end
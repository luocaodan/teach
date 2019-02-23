class SprintsController < ApplicationController
  def show
    respond_to do |format|
      format.json do
        project_id = params[:project_id]
        milestone_id = params[:milestone_id]
        sprint_info = sprints_service.get_sprint(project_id, milestone_id)
        render json: sprint_info
      end
    end
  end

  def update
    respond_to do |format|
      format.json do
        project_id = params[:project_id]
        milestone_id = params[:milestone_id]
        update = params[:update]
        sprint_info = sprints_service.update_sprint(project_id, milestone_id, update)
        render json: sprint_info
      end
    end
  end

  def sprints_service
    ::SprintsService.new(current_user)
  end
end

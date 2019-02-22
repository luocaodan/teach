class SprintsController < ApplicationController
  def show
    respond_to do |format|
      format.json do
        project_id = params[:project_id]
        milestone_id = params[:milestone_id]
        sprint_info = sprints_service.get_sprints(project_id, milestone_id)
        render json: sprint_info
      end
    end
  end

  def sprints_service
    ::SprintsService.new(current_user)
  end
end

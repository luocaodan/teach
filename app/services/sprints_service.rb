class SprintsService < BaseService
  def get_sprint(project_id, milestone_id)
    get "projects/#{project_id}/milestones/#{milestone_id}"
  end

  def update_sprint(project_id, milestone_id, update)
    put "projects/#{project_id}/milestones/#{milestone_id}", update
  end
end
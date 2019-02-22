class SprintsService < BaseService
  def get_sprints(project_id, milestone_id)
    get "projects/#{project_id}/milestones/#{milestone_id}"
  end
end
module ClassroomsHelper
  def auto_test_path(project)
    auto_test_project = AutoTestProject.find_by(gitlab_id: project['id'])
    classroom_auto_test_project_path(classroom_id: params[:id], id: auto_test_project.id)
  end

  def team_panel_path(project)
    team_project = TeamProject.find_by(gitlab_id: project['id'])
    classroom_team_project_path(classroom_id: params[:id], id: team_project.id)
  end
end

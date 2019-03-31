module TeamProjectsHelper
  def classroom_path_team_project_prefix
    classroom = Classroom.find(params[:classroom_id])
    team_project_group_id = classroom.team_project_subgroup_id
    team_project_group = groups_service.get_group team_project_group_id
    "#{gitlab_host}/#{team_project_group['full_path']}/"
  end

  private

  def groups_service
    ::GroupsService.new current_user
  end
end

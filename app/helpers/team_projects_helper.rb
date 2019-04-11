module TeamProjectsHelper
  def classroom_path_team_project_prefix
    classroom = Classroom.find(params[:classroom_id])
    team_project_group_id = classroom.team_project_subgroup_id
    team_project_group = groups_service.get_group team_project_group_id
    "#{gitlab_host}/#{team_project_group['full_path']}/"
  end

  def my_team?(project)
    member = get_project_member project['id'], current_user.id
    true
  rescue RestClient::NotFound
    false
  end

  private

  def groups_service
    ::GroupsService.new current_user
  end

  def get_project_member(project_id, user_id)
    admin_api_get "projects/#{project_id}/members/#{user_id}"
  end
end

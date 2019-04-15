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

  def insight_data
    team_project = TeamProject.find(params[:team_project_id])
    members = get_project_members team_project.gitlab_id
    {
      members: members.to_json,
      endpoint: classroom_team_project_insight_path(format: :json)
    }
  end

  private

  def groups_service
    ::GroupsService.new current_user
  end

  def get_project_member(project_id, user_id)
    admin_api_get "projects/#{project_id}/members/#{user_id}"
  end

  def get_project_members(project_id)
    admin_api_get "projects/#{project_id}/members"
  end
end

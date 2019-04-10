class TeamProjectsController < ApplicationController
  def new
    @errors = []
    @team_project = {
      name: '',
      path: '',
      description: '',
      initialize_with_readme: false
    }
  end

  def create
    @team_project = params[:team_project]
    @team_project[:initialize_with_readme] = !!@team_project[:initialize_with_readme]
    classroom = Classroom.find(params[:classroom_id])
    team_project = {
      name: @team_project['name'],
      path: @team_project['path'],
      description: @team_project['description'],
      initialize_with_readme: @team_project[:initialize_with_readme],
      namespace_id: classroom.team_project_subgroup_id
    }
    # 以 owner 身份创建项目
    owner = classroom.users.where(role: 'teacher').first
    @team_project = create_project_as_owner team_project, owner.gitlab_id
    # 当前用户添加为 Maintainer
    add_project_master_as_owner @team_project['id'], current_user.id, owner.gitlab_id
    redirect_to @team_project['web_url']
  rescue RestClient::BadRequest => e
    @errors = ['名称或地址包含非法字符']
    render 'new'
  end

  private

  def create_project_as_owner(project, owner_id)
    admin_api_post "projects?sudo=#{owner_id}", project
  end

  def add_project_master_as_owner(project_id, user_id, owner_id)
    maintainer = 40
    user = {
      user_id: user_id,
      access_level: maintainer
    }
    admin_api_post "projects/#{project_id}/members?sudo=#{owner_id}", user
  end
end

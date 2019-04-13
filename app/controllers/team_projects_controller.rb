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

  def show
    team_project = TeamProject.find(params[:id])
    @team = get_project team_project.gitlab_id
    @members = get_project_members team_project.gitlab_id
    commits = team_project.contribution_commits
    issues = team_project.contribution_issues
    @total = Issue.where(project_id: team_project.gitlab_id).count
    @total_weight = Issue.where(project_id: team_project.gitlab_id).sum { |i| i.weight.to_i }
    @done = issues.count
    @done_weight = issues.select(:weight).joins(:issue).sum { |i| i.weight.to_i }
    @percent = @total.zero? ? 100 : @done / @total
    @percent_weight = @total_weight.zero? ? 100 : @done_weight / @total_weight
    @members.each do |member|
      member['role'] = team_role member.delete('access_level')
      user = User.find_by gitlab_id: member['id']
      member['commits_count'] = commits.where(user_id: user.id).count
      member['issues_count'] = issues.where(user_id: user.id).count
      member['issues_weight'] = issues.select(:weight)
                                      .where(user_id: user.id)
                                      .joins(:issue)
                                      .sum { |i| i.weight.to_i }
    end
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

  def get_project(project_id)
    admin_api_get "projects/#{project_id}"
  end

  def get_project_members(project_id)
    admin_api_get "projects/#{project_id}/members"
  end

  def team_role(access_level)
    # access_level: 10 | 20 | 30 | 40 | 50
    access = %w[Guest Reporter Developer Maintainer Owner]
    access[access_level / 10 - 1]
  end
end

require 'set'

class SystemController < ApplicationController
  skip_before_action :require_login, only: [:index]
  # gitlab system hook
  def index
    # 自动测试项目和团队项目标记
    if %w[project_transfer project_create].include? params['event_name']
      mark_auto_test_project params['project_id']
      mark_team_project params['project_id']
    end
    # 添加 webhook 和 默认label
    if params['event_name'] == 'project_create'
      add_webhook params['project_id']
      add_default_labels params['project_id']
    end
    # 删除项目自动删除 active record
    if params['event_name'] == 'project_destroy'
      remove_project_record params['project_id']
    end
    render json: {status: 'success'}
  end

  private

  def add_webhook(project_id)
    url = "projects/#{project_id}/hooks"
    data = {}
    data[:url] = webhook_url
    data[:push_events] = true
    data[:issue_events] = true
    res = {}
    res = admin_api_post url, data until res.key?('id')
  end

  def add_default_labels(project_id)
    red = '#d9534f'
    yellow = '#f0ad4e'
    blue = '#428bca'
    green = '#5cb85c'
    purple = '#5843ad'

    labels = [
      {name: 'bug', color: red},
      {name: 'critical', color: red},
      {name: 'confirmed', color: red},
      {name: 'documentation', color: yellow},
      {name: 'support', color: yellow},
      {name: 'discussion', color: blue},
      {name: 'suggestion', color: blue},
      {name: 'enhancement', color: green},
      {name: 'feature', color: purple},
      {name: 'To Do', color: yellow},
      {name: 'Doing', color: green}
    ]
    url = "projects/#{project_id}/labels"
    labels.each do |label|
      admin_api_post url, label
    end
  end

  def mark_auto_test_project(project_id)
    group_id = get_group_id project_id
    return unless group_id
    classroom = Classroom.find_by(personal_project_subgroup_id: group_id)
    classroom ||= Classroom.find_by(pair_project_subgroup_id: group_id)
    classroom&.auto_test_projects&.create(gitlab_id: project_id)
  end

  def mark_team_project(project_id)
    group_id = get_group_id project_id
    return unless group_id
    classroom = Classroom.find_by(team_project_subgroup_id: group_id)
    classroom&.team_projects&.create(gitlab_id: project_id)
  end

  def get_group_id(project_id)
    project = admin_api_get "projects/#{project_id}"
    return nil unless project['namespace']['kind'] == 'group'
    group_id = project['namespace']['id']
    return nil unless group_id
    return group_id
  end

  def get_members(project_id)
    admin_api_get "projects/#{project_id}/members/all"
  end

  def remove_project_record(project_id)
    auto_test_project = AutoTestProject.find_by(gitlab_id: project_id)
    auto_test_project&.destroy
    team_project = TeamProject.find_by(gitlab_id: project_id)
    team_project&.destroy
  end
end

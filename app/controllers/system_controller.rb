class SystemController < ApplicationController
  skip_before_action :require_login, only: [:index]
  # gitlab system hook
  def index
    if %w[project_transfer project_create].include? params['event_name']
      mark_auto_test_project params['project_id']
      mark_team_project params['project_id']
    end
    if params['event_name'] == 'project_create'
      add_webhook params['project_id']
      add_default_labels params['project_id']
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
end

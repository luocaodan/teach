class SystemController < ApplicationController
  skip_before_action :require_login, only: [:index]
  # gitlab system hook
  def index
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

    labels = [
      {name: 'bug', color: red},
      {name: 'critical', color: red},
      {name: 'confirmed', color: red},
      {name: 'documentation', color: yellow},
      {name: 'support', color: yellow},
      {name: 'discussion', color: blue},
      {name: 'suggestion', color: blue},
      {name: 'enhancement', color: green},
      {name: 'To Do', color: yellow},
      {name: 'Doing', color: green}
    ]
    url = "projects/#{project_id}/labels"
    labels.each do |label|
      admin_api_post url, label
    end
  end
end

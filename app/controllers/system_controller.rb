class SystemController < ApplicationController
  skip_before_action :require_login, only: [:index]
  # gitlab system hook
  def index
    if params['event_name'] == 'project_create'
      add_webhook params['project_id']
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
    until res.key?('id') do
      res = admin_api_post url, data
      res = JSON.parse(res)
    end
  end
end

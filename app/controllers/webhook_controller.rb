class WebhookController < ApplicationController
  skip_before_action :require_login, only: [:index]

  def index
    event = params[:webhook]
    issue_state_handler(event)
  end

  private

  def issue_state_handler(event)
    return unless event['object_kind'] == 'issue'
    issue = event['object_attributes']
    issue_record = Issue.find(issue['id'])
    unless issue_record
      issue_record = Issue.new id: issue['id']
    end
    issue_record.project_id = event['project']['id']
    issue_record.milestone_id = issue['milestone_id']
    if issue['state'] == 'closed'
      issue_record.state = 'Closed'
    else
      labels = event['labels']
      label_titles = labels.each_with_object([]) {|l, a| a << l['title']}
      todo = label_titles.delete 'To Do'
      doing = label_titles.delete 'Doing'
      issue_record.state = if doing
                             doing
                           elsif todo
                             todo
                           else
                             'Open'
                           end
    end
    issue_record.save
  end
end

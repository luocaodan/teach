class IssuesController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        issues_info = issues_service.all filter_params.to_h
        render json: issues_info
      end
      format.html
    end
  end

  def create
    respond_to do |format|
      format.json do
        issue = params[:issue]
        payload = {
          title: issue['title'],
          description: issue['description']
        }
        issue_info = issues_service.new_issue issue.delete('project_id'), payload
        render json: issue_info
      end
    end
  end

  private

  def filter_params
    params.permit :project, :labels, :state, :scope, :assignee_id
  end

  def issues_service
    ::IssuesService.new(current_user)
  end
end

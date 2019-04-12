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

  def all_issues
    respond_to do |format|
      format.json do
        issues_info = issues_service.all_issues filter_params.to_h
        render json: issues_info
      end
    end
  end

  def create
    respond_to do |format|
      format.json do
        issue = params[:issue]
        # 自动标记为todo
        issue['labels'] << 'To Do'
        payload = {
          title: issue['title'],
          description: issue['description'],
          assignee_ids: issue['assignee'],
          milestone_id: issue['milestone'],
          labels: issue['labels'].join(','),
          due_date: issue['due_date'],
          weight: issue['weight'],
          priority: issue['priority']
        }
        issue_info = issues_service.new_issue issue.delete('project_id'), payload
        render json: issue_info
      end
    end
  end

  def update
    respond_to do |format|
      format.json do
        update = params[:update_issue]
        id = update[:id]
        project_id = update[:project_id]
        iid = update[:iid]
        payload = {
          attr: update[:attr],
          value: update[:value]
        }
        issue_info = issues_service.update_issue id, project_id, iid, payload
        render json: issue_info
      end
    end
  end

  private

  def filter_params
    params.permit(
      :project, :labels, :state, :assignee_id,
            :milestone, :milestone_id, :page, :per_page
    )
  end

  def issues_service
    ::IssuesService.new(current_user)
  end
end

class IssuesController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        issues_service = ::IssuesService.new(current_user)
        issues_info = issues_service.all filter_params.to_h
        render json: issues_info
      end
      format.html
    end
  end

  private

  def filter_params
    params.permit :project, :labels, :state, :scope, :assignee_id
  end
end

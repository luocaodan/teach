require 'time'

class InsightController < ApplicationController
  def show
    respond_to do |format|
      format.json do
        data = contribution_data
        render json: data
      end
      format.html
    end
  end

  private

  def contribution_data
    contribution_type = params[:type]
    case contribution_type
    when 'Issues'
      contribution_service.issues_data
    when 'Weight'
      contribution_service.weight_data
    else
      contribution_service.commits_data
    end
  end

  def time_range
    from = Time.parse params[:from]
    to = Time.parse params[:to]
    from..to
  end

  def contribution_service
    ::ContributionService.new params[:team_project_id], params[:member], time_range
  end
end

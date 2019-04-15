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
    contribution_type = params.delete :type
    case contribution_type
    when 'Issues'
      issues_data
    when 'Weight'
      weight_data
    else
      commits_data
    end
  end

  def issues_data
    # 按本地时间分组
    issues.where(closed_at: time_range)
          .group_by { |i| i.closed_at.localtime.to_date }
          .map { |k, v| [k, v.length] }
          .sort
  end

  def weight_data
    issues.select(:weight, :closed_at)
          .where(closed_at: time_range)
          .joins(:issue)
          .group_by { |i| i.closed_at.localtime.to_date }
          .map { |k, v| [k, v.sum { |i| i.weight.to_i }] }
          .sort
  end

  def commits_data
    commits.where(committed_at: time_range)
           .group_by { |i| i.committed_at.localtime.to_date }
           .map { |k, v| [k, v.length]}
           .sort
  end

  def issues
    team = current_team
    issues = team.contribution_issues
    if params[:member]
      user = User.find_by gitlab_id: params[:member]
      issues = issues.where user_id: user
    end
    issues
  end

  def commits
    team = current_team
    commits = team.contribution_commits
    if params[:member]
      user = User.find_by gitlab_id: params[:member]
      commits = commits.where user_id: user
    end
    commits
  end

  def time_range
    from = Time.parse params[:from]
    to = Time.parse params[:to]
    from..to
  end

  def current_team
    TeamProject.find(params[:team_project_id])
  end
end

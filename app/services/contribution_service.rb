class ContributionService

  def initialize(team_project_id, member_gitlab_id = nil, time_range = nil)
    @team = TeamProject.find(team_project_id)
    @member = User.find_by gitlab_id: member_gitlab_id
    @time_range = time_range
  end

  def issues_data
    # 按本地时间分组
    issues
      .group_by {|i| i.closed_at.localtime.to_date}
      .map {|k, v| [k, v.length]}
      .sort
  end

  def weight_data
    issues
      .select(:weight, :closed_at)
      .joins(:issue)
      .group_by {|i| i.closed_at.localtime.to_date}
      .map {|k, v| [k, v.sum {|i| i.weight.to_i}]}
      .sort
  end

  def commits_data
    commits
      .group_by {|i| i.committed_at.localtime.to_date}
      .map {|k, v| [k, v.length]}
      .sort
  end

  private

  def issues
    issues = @team.contribution_issues
    issues = issues.where user_id: @member if @member
    issues = issues.where closed_at: @time_range if @time_range
    issues
  end

  def commits
    commits = @team.contribution_commits
    commits = commits.where user_id: @member if @member
    commits = commits.where committed_at: @time_range if @time_range
    commits
  end
end
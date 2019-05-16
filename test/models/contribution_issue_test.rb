require 'test_helper'

class ContributionIssueTest < ActiveSupport::TestCase
  test "should not save without team_project_id" do
    issue = ContributionIssue.new
    assert_not issue.save
  end

  team_project = TeamProject.first

  test "should not save without user_id" do
    issue = team_project.contribution_issues.new
    assert_not issue.save
  end

  user = User.first

  test "should save with team_project_id and user_id" do
    issue = team_project.contribution_issues.new user_id: user.id
    assert issue.save
  end
end

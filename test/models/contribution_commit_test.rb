require 'test_helper'

class ContributionCommitTest < ActiveSupport::TestCase
  test "should not save without team_project_id" do
    commit = ContributionCommit.new
    assert_not commit.save
  end

  team_project = TeamProject.first

  test "should not save without user_id" do
    commit = team_project.contribution_commits.new
    assert_not commit.save
  end

  user = User.first

  test "should not save without gitlab_id" do
    commit = team_project.contribution_commits.new user_id: user.id
    assert_not commit.save
  end

  test "should not save with exist gitlab_id" do
    commit = team_project.contribution_commits.new user_id: user.id, gitlab_id: 1
    assert_not commit.save
  end

  test "should save with user_id, team_project_id and gitlab_id" do
    commit = team_project.contribution_commits.new user_id: user.id, gitlab_id: 2
    assert commit.save
  end
end

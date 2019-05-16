require 'test_helper'

class TeamProjectTest < ActiveSupport::TestCase
  test "should not save without gitlab id" do
    team_project = TeamProject.new
    assert_not team_project.save
  end

  test "should not save without classroom_id" do
    team_project = TeamProject.new gitlab_id: 1
    assert_not team_project.save
  end

  classroom = Classroom.first

  test "should not save with exist gitlab_id" do
    team_project = classroom.team_projects.new gitlab_id: 1
    assert_not team_project.save
  end

  test "should save with gitlab_id and classroom_id" do
    team_project = classroom.team_projects.new gitlab_id: 3
    assert team_project.save
  end
end

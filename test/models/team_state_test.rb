require 'test_helper'

class TeamStateTest < ActiveSupport::TestCase
  test "should not save only with team_event_id" do
    team_event = TeamEvent.first
    team_state = TeamState.new team_event_id: team_event.id
    assert_not team_state.save
  end


  test "should not save only with team_project_id" do
    team_project = TeamProject.first
    team_state = TeamState.new team_project_id: team_project.id
    assert_not team_state.save
  end

  test "should save with team_event_id and team_project_id" do
    team_event = TeamEvent.first
    team_project = TeamProject.first
    team_state = TeamState.new team_project_id: team_project.id, team_event_id: team_event.id
    assert team_state.save
  end
end

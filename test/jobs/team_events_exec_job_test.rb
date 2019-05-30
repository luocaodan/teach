require 'test_helper'

class TeamEventsExecJobTest < ActiveJob::TestCase
  setup do
    @event = team_events(:one)
    @team_project_1 = team_projects(:one)
    @team_project_2 = team_projects(:two)
  end

  test "event is executed" do
    TeamEventsExecJob.perform_now @event.classroom.team_project_ids, [@event]
    # exec success
    assert true
  end

  test "default state" do
    TeamEventsExecJob.perform_now [@team_project_2.id], [@event]
    team_state = TeamState.find_by(team_event_id: @event.id, team_project_id: @team_project_2.id)
    assert_equal '暂无 Commit 或 Issues 数据', team_state.state
  end

  test "generate state successfully" do
    TeamEventsExecJob.perform_now [@team_project_1.id], [@event]
    team_state = TeamState.find_by(team_event_id: @event.id, team_project_id: @team_project_1.id)
    assert_equal 'haha', team_state.state
  end
end

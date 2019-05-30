require 'test_helper'

class TimedTeamEventsJobTest < ActiveJob::TestCase
  setup do
    @event = team_events(:one)
    @team_project_1 = team_projects(:one)
    @team_project_2 = team_projects(:two)
  end

  test "event is executed" do
    TimedTeamEventsJob.perform_now
    # exec success
    assert true
  end

  test "default state" do
    TimedTeamEventsJob.perform_now
    team_state = TeamState.find_by(team_event_id: @event.id, team_project_id: @team_project_2.id)
    assert_equal '暂无 Commit 或 Issues 数据', team_state.state
  end

  test "generate state successfully" do
    TimedTeamEventsJob.perform_now
    team_state = TeamState.find_by(team_event_id: @event.id, team_project_id: @team_project_1.id)
    assert_equal 'haha', team_state.state
  end
end

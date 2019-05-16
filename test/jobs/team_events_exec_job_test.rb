require 'test_helper'

class TeamEventsExecJobTest < ActiveJob::TestCase
  setup do
    @event = team_events(:one)
  end

  test "event is executed" do
    TeamEventsExecJob.perform_now @event.classroom.team_project_ids, [@event]
    assert true
  end
end

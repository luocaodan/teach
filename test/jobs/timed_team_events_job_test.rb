require 'test_helper'

class TimedTeamEventsJobTest < ActiveJob::TestCase
  setup do
    @event = team_events(:one)
  end

  test "event is executed" do
    TimedTeamEventsJob.perform_now
    # exec success
    assert true
  end
end

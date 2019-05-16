require 'test_helper'

class TeamEventTest < ActiveSupport::TestCase
  test "should not save without name" do
    team_event = TeamEvent.new
    assert_not team_event.save
  end


  test "should not save without description" do
    team_event = TeamEvent.new name: 'event haha'
    assert_not team_event.save
  end

  test "should not save without code" do
    team_event = TeamEvent.new name: 'event haha', description: 'haha'
    assert_not team_event.save
  end

  test "should not save without classroom_id" do
    team_event = TeamEvent.new name: 'event haha', description: 'haha'
    assert_not team_event.save
  end

  test "should not save with exist name" do
    classroom = Classroom.first
    team_event = classroom.team_events.new name: 'event1', description: 'haha', code: 'some code'
    assert_not team_event.save
  end


  test "should save with other name, description and code" do
    classroom = Classroom.first
    team_event = classroom.team_events.new name: 'other name', description: 'haha', code: 'some code'
    assert team_event.save
  end
end

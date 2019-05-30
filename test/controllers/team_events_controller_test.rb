require 'test_helper'

class TeamEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @c_id = classrooms(:one).id
    @e_id = team_events(:one).id
  end

  test "should get index" do
    get classroom_team_events_url(classroom_id: @c_id)
    assert_equal 'index', @controller.action_name
  end

  test "should get new" do
    get new_classroom_team_event_url(classroom_id: @c_id)
    assert_equal 'new', @controller.action_name
  end

  test "should create team_event" do
    post classroom_team_events_url(classroom_id: @c_id)
    assert_equal 'create', @controller.action_name
  end

  test "should show team_event" do
    get classroom_team_event_url(classroom_id: @c_id, id: @e_id)
    assert_equal 'show', @controller.action_name
  end

  test "should get edit" do
    get edit_classroom_team_event_url(classroom_id: @c_id, id: @e_id)
    assert_equal 'edit', @controller.action_name
  end

  test "should update team_event" do
    put classroom_team_event_url(classroom_id: @c_id, id: @e_id)
    assert_equal 'update', @controller.action_name
  end

  test "should destroy team_event" do
    delete classroom_team_event_url(classroom_id: @c_id, id: @e_id)
    assert_equal 'destroy', @controller.action_name
  end
end

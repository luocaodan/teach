require 'test_helper'

class TeamProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @c_id = classrooms(:one).id
    @t_id = team_projects(:one).id
  end

  test "should get new" do
    get new_classroom_team_project_url(classroom_id: @c_id)
    assert_equal 'new', @controller.action_name
  end

  test "should create team_project" do
    post classroom_team_projects_url(classroom_id: @c_id)
    assert_equal 'create', @controller.action_name
  end

  test "should show team_project" do
    get classroom_team_project_url(classroom_id: @c_id, id: @t_id)
    assert_equal 'show', @controller.action_name
  end

  test "should not destroy team_project" do
    begin
      delete classroom_team_project_url(classroom_id: @c_id, id: @t_id)
      assert false
    rescue
      assert true
    end
  end
end

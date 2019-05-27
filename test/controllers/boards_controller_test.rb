require 'test_helper'

class BoardsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get kanban_project_url(project_id: 1)
    assert_equal 'index', @controller.action_name
    get kanban_milestone_url(project_id: 1, milestone_id: 1)
    assert_equal 'index', @controller.action_name
  end
end

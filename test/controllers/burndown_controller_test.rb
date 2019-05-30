require 'test_helper'

class BurndownControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get burndown_milestone_path(milestone_id: 1)
    assert_equal 'index', @controller.action_name
  end
end

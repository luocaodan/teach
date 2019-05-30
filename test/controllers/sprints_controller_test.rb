require 'test_helper'

class SprintsControllerTest < ActionDispatch::IntegrationTest
  test "should show sprint" do
    get sprint_url(id: 1)
    assert_equal 'show', @controller.action_name
  end

  test "should update sprint" do
    put sprint_url(id: 1)
    assert_equal 'update', @controller.action_name
  end
end

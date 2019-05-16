require 'test_helper'

class SystemControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    post system_path, params: {system: {haha: 1}}
    assert_response :success
  end
end

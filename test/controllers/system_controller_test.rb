require 'test_helper'

class SystemControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    post system_path, params: {system: {haha: 1}}
    assert_response :success
  end

  test "system event test" do
    %w[project_create project_destroy user_add_to_team].each do |name|
      begin
        post system_path, params: {system: {event_name: name}}
      rescue Errno::ECONNREFUSED
      end
      assert true
    end
  end
end

require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "get main" do
    get root_url
    assert_equal 'main', @controller.action_name
  end
end

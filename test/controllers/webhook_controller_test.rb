require 'test_helper'

class WebhookControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get webhook_url
    assert_equal 'index', @controller.action_name
  end

  test "issue event" do
  end

  test "push event" do
  end
end

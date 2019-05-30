require 'test_helper'

class ReportControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    post report_url
    assert 'index', @controller.action_name
  end

  test "authenticate" do
  end
end

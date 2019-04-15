require 'test_helper'

class InsightControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get insight_show_url
    assert_response :success
  end

end

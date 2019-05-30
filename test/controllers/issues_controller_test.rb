require 'test_helper'

class IssuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @i_id = issues(:one)
  end
  test "should get index" do
    get issues_url
    assert_equal 'index', @controller.action_name
  end

  test "should get create" do
    post issues_url
    assert_equal 'create', @controller.action_name
  end

  test "should get update" do
    put issue_url(id: @i_id)
    assert_equal 'update', @controller.action_name
  end
end

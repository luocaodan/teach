require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get blog_comments_url(blog_id: 1, format: :json)
    assert_equal 'index', @controller.action_name
  end


  test "should get create" do
    post blog_comments_url(blog_id: 1, format: :json)
    assert_equal 'create', @controller.action_name
  end


  test "should get update" do
    put blog_comment_url(blog_id: 1, id: 1, format: :json)
    assert_equal 'update', @controller.action_name
  end


  test "should get destroy" do
    delete blog_comment_url(blog_id: 1, id: 1, format: :json)
    assert_equal 'destroy', @controller.action_name
  end
end

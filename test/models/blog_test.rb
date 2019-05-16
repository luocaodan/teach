require 'test_helper'

class BlogTest < ActiveSupport::TestCase
  test "should not save without classroom_id" do
    b = Blog.new
    assert_not b.save
  end

  classroom = Classroom.first

  test "should not save without user_id" do
    b = classroom.blogs.new
    assert_not b.save
  end

  user = User.first

  test "should not save without project_id" do
    b = classroom.blogs.new user_id: user.id
    assert_not b.save
  end

  test "should not save without gitlab_id" do
    b = classroom.blogs.new user_id: user.id, project_id: 1
    assert_not b.save
  end


  test "should not save without blog_type" do
    b = classroom.blogs.new user_id: user.id, project_id: 1, gitlab_id: 2
    assert_not b.save
  end

  test "should not save with exist gitlab_id" do
    b = classroom.blogs.new user_id: user.id, project_id: 1, blog_type: 'blog', gitlab_id: 1
    assert_not b.save
  end

  test "should save" do
    b = classroom.blogs.new user_id: user.id, project_id: 1, blog_type: 'blog', gitlab_id: 2
    assert b.save
  end
end

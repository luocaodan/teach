require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should not save user without gitlab_id" do
    user = User.new
    assert_not user.save
  end

  test "should not save user without username" do
    user = User.new gitlab_id: 1
    assert_not user.save
  end

  test "should save user with gitlab_id and username" do
    user = User.new gitlab_id: 1, username: 'sam'
    assert user.save
  end
end

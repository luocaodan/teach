require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @u_id = users(:one).id
    @c_id = classrooms(:one).id
  end

  test "should get new" do
    get new_classroom_user_url(classroom_id: @c_id)
    assert_equal 'new', @controller.action_name
  end

  test "should create user" do
    post classroom_users_url(classroom_id: @c_id)
    assert_equal 'create', @controller.action_name
  end

  test "should destroy user" do
    delete classroom_user_url(classroom_id: @c_id, id: @u_id)
    assert_equal 'destroy', @controller.action_name
  end
end

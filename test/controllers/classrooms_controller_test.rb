require 'test_helper'

class ClassroomsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @c_id = classrooms(:one)
  end

  test "should get index" do
    get classrooms_url
    assert_equal 'index', @controller.action_name
  end

  test "should get new" do
    get new_classroom_url
    assert_equal 'new', @controller.action_name
  end

  test "should get create" do
    post classrooms_url
    assert_equal 'create', @controller.action_name
  end

  test "should get destroy" do
    delete classroom_url(id: @c_id)
    assert_equal 'destroy', @controller.action_name
  end

  test "should get show" do
    get classroom_url(id: @c_id)
    assert_equal 'show', @controller.action_name
  end

  test "should get join" do
    get join_classroom_url(id: @c_id)
    assert_equal 'join', @controller.action_name
  end

  test "should get exit" do
    get exit_classroom_url(id: @c_id)
    assert_equal 'exit', @controller.action_name
  end
end

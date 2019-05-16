require "application_system_test_case"

class SessionsTest < ApplicationSystemTestCase
  test "visiting the student login page" do
    visit login_url

    assert_selector "#login a:nth-of-type(1)", text: "学生登录"
  end

  test "visiting the teacher login page" do
    visit login_url

    assert_selector "#login a:nth-of-type(2)", text: "教师登录"
  end
end

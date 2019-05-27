require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "helpers" do
    projects_data
    assert true
  end

  def teacher?
    true
  end
end
require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  test "should not save without project_id" do
    issue = Issue.new
    assert_not issue.save
  end

  test "should save with project_id" do
    issue = Issue.new project_id: 1
    assert issue.save
  end
end

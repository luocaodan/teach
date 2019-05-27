require 'test_helper'

class CommentsHelperTest < ActionView::TestCase
  test "helpers" do
    assert comments_data
  end

  def params
    {id: 1}
  end
end
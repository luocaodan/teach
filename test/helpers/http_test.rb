require 'test_helper'

class HttpTest < ActionView::TestCase
  URI = 'http://ip.cn'

  test "http request" do
    assert Http.get URI
  end
end
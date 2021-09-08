require 'test_helper'
class HashTest < ActiveSupport::TestCase



  test 'leaves ok' do
    h = {
      a: 1,
      b: { c: 2 }
    }

    assert_equal [1, 2], h.leaves
  end

end

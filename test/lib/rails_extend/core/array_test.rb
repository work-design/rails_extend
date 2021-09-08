require 'test_helper'
class ArrayTest < ActiveSupport::TestCase

  test 'ljust!' do
    ary = [1]
    assert_equal [0, 0, 1], ary.ljust!(3, 0)
    assert_equal [0, 0, 1], ary
  end

  test 'rjust!' do
    ary = [1]
    assert_equal [1, 0, 0], ary.rjust!(3, 0)
    assert_equal [1, 0, 0], ary
  end

  test 'mjust!' do
    ary = [1, 2, 3]
    assert_equal [1, 2, 0, 0, 3], ary.mjust!(5, 0)

    ary1 = [1, 2]
    assert_equal [1, 0, 0, 2], ary1.mjust!(4, 0)
  end

  test 'to_combine_h' do
    ary = [
      { a: 1 },
      { a: 2 }
    ]
    exp = { a: [1, 2] }
    assert_equal exp, ary.to_combine_h
  end

  test 'to_array_h' do
    ary = [
      [:a, 1],
      [:a, 2, 3],
      [:b, 3]
    ]
    exp = [
      { a: 1 },
      { a: 2 },
      { b: 3 }
    ]
    assert_equal exp, ary.to_array_h
  end

end

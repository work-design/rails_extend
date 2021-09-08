require 'test_helper'
class DateTest < ActiveSupport::TestCase

  test 'contract_after' do
    d = '2020-01-01'.to_date
    exp_less = '2020-02-29'.to_date
    exp_more = '2020-03-01'.to_date
    assert_equal exp_less, d.contract_after(2.months)
    assert_equal exp_more, d.contract_after(2.months, less: false)
  end

  test 'parts' do
    d = '2020-01-01'.to_date
    exp = {
      year: 2020,
      month: 1,
      day: 1
    }
    assert_equal exp, d.parts
  end

end

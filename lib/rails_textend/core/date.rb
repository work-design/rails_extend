class Date

  # Chinese custom after date
  #   '2018-01-01'.to_date.contract_after(2.month) => '2018-02-31'
  #   '2018-01-31'.to_date.contract_after(1.month) => '2018-02-28'
  def contract_after(*afters, less: true)
    parts = {}
    # todo use inject or something
    afters.each do |after|
      parts.merge! after.parts
    end
    r = ActiveSupport::Duration.new(0, parts).after(self)

    return r unless less

    # if result day less than day, so
    if (parts.keys & [:months, :years]).present?
      r.day < day ? r : r - 1
    else
      r
    end
  end

  def parts
    {
      year: year,
      month: month,
      day: day
    }
  end

end

class Numeric

  def half_round
    (self * 2).round / 2.0
  end

  def half_floor
    (self * 2).floor / 2.0
  end

end

class BigDecimal

  def inspect
    to_formatted_s(:delimited)
  end

end

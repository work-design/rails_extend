class NilClass

  def to_d
    BigDecimal(0)
  end
  
  def to_sym
    to_s.to_sym
  end

end

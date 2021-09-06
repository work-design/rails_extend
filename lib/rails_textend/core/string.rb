class String

  def integer?
    Integer(self).is_a?(Integer)
  rescue ArgumentError, TypeError
    false
  end

  def numeric?
    Float(self).is_a?(Numeric)
  rescue ArgumentError, TypeError
    false
  end

end
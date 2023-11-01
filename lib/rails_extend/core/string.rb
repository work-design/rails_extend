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

  def to_controller
    r = camelize
    if r.end_with?('Controller')
      r.safe_constantize
    else
      "#{r}Controller".safe_constantize
    end
  end

end

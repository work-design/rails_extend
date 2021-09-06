class Pathname

  # like present? and presence
  # if exist? return self
  def existence
    self if exist?
  end

  # xx.html.erb => xx
  def without_extname
    suffix = basename.to_s.split('.')[0]
    dirname.join(suffix)
  end

end

class Pathname

  # xx.html.erb => xx
  def without_extname
    suffix = basename.to_s.split('.')[0]
    dirname.join(suffix)
  end

end

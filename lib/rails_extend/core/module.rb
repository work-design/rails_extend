class Module

  def root_module
    name.split('::')[0].constantize
  end

end

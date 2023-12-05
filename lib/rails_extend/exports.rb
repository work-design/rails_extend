# frozen_string_literal: true

module RailsExtend::Exports
  extend self

  def exports
    return @exports if defined? @exports
    Zeitwerk::Loader.eager_load_all
    @exports = ApplicationExport.descendants
  end

  def imports
    return @imports if defined? @imports
    Zeitwerk::Loader.eager_load_all
    @imports = ApplicationImport.descendants
  end

end

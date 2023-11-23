# frozen_string_literal: true
module RailsExtend::ActionDispatch
  module Generator

    def use_relative_controller!
      super

      RailsExtend::Routes@options[:controller]
    end

  end
end

ActionDispatch::Routing::RouteSet::Generator.prepend RailsExtend::ActionDispatch::Generator

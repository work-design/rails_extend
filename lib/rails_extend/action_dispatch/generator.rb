# frozen_string_literal: true
module RailsExtend::ActionDispatch
  module Generator

    def use_relative_controller!
      _controller = @options[:controller]

      super

      return if RailsExtend::Routes._controllers.key?(@options[:controller])
      @options[:controller] = _controller
    end

  end
end

ActionDispatch::Routing::RouteSet::Generator.prepend RailsExtend::ActionDispatch::Generator

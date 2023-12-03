# frozen_string_literal: true
module RailsExtend::ActionDispatch
  module Generator

    def use_relative_controller!
      _controller = @options[:controller]

      if !named_route && different_controller? && !controller.start_with?('/') && controller.count('/') > 0
        path = (current_controller.split('/')[0..-2] << controller).join('/')
        return @options[:controller] = path if RailsExtend::Routes._controllers.key?(path)
      end

      if !named_route && different_controller? && !controller.start_with?('/') && current_controller.count('/') >= 3
        path = (current_controller.split('/')[0..-3] << controller).join('/')
        return @options[:controller] = path if RailsExtend::Routes._controllers.key?(path)
      end

      super

      return if RailsExtend::Routes._controllers.key?(@options[:controller])
      @options[:controller] = _controller
    end

  end
end

ActionDispatch::Routing::RouteSet::Generator.prepend RailsExtend::ActionDispatch::Generator

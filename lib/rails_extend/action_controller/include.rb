module RailsExtend::ActionController
  module Include
    extend ActiveSupport::Concern

    included do
      helper_method :referer_meta, :referer_controller
    end

    def whether_filter(filter)
      callback = self.__callbacks[:process_action].find { |i| i.filter == filter.to_sym }
      return false unless callback

      _if = callback.instance_variable_get(:@if).map do |c|
        c.match?(self)
      end

      _unless = callback.instance_variable_get(:@unless).map do |c|
        !c.match?(self)
      end

      !(_if + _unless).uniq.include?(false)
    end

    def valid_ivars
      _except = _protected_ivars.to_a + [
        :@marked_for_same_origin_verification,
        :@_referer_meta
      ]
      self.instance_variables - _except
    end

    def referer_meta
      return @_referer_meta if defined? @_referer_meta
      @_referer_meta = Rails.application.routes.recognize_path(request.referer)
    end

    def referer_controller
      referer_meta[:controller]
    end

    def proper_layout
      _prefixes.find { |i| lookup_context.exists?(i, ['layouts'], formats: formats) }
    end

  end
end

ActiveSupport.on_load :action_controller_base do
  include RailsExtend::ActionController::Include
end

module RailsExtend::ActionController
  module Include

    def whether_filter(filter)
      callback = self.__callbacks[:process_action].find { |i| i.filter == filter.to_sym }
      return false unless callback

      _if = callback.instance_variable_get(:@if).map do |c|
        c.call(self)
      end

      _unless = callback.instance_variable_get(:@unless).map do |c|
        !c.call(self)
      end

      !(_if + _unless).uniq.include?(false)
    end

    def valid_ivars
      _except = _protected_ivars.to_a + [
        :@marked_for_same_origin_verification
      ]
      self.instance_variables - _except
    end

  end
end

ActiveSupport.on_load :action_controller do
  include RailsExtend::ActionController::Include
end

module RailsExtend::ActionController
  module Prepend

    private
    # 支持在views/:controller 目录下，用 _action 开头的子目录进一步分组，会优先查找该目录下文件
    def _prefixes
      _action_name = (request&.params || {})['action']

      if self.class.superclass.action_methods.include?(_action_name)
        pres = ["#{controller_path}/_#{_action_name}", "#{self.class.superclass.controller_path}/_#{_action_name}"] + super
      else
        pres = ["#{controller_path}/_#{_action_name}"] + super
      end

      if defined?(current_organ) && current_organ&.code.present?
        pres = ["#{current_organ.code}/views/#{controller_path}", "#{current_organ.code}/views"] + pres
      end

      pres
    end

  end
end

ActiveSupport.on_load :action_controller do
  prepend RailsExtend::ActionController::Prepend
end

module RailsExtend::ActionController
  module Prepend

    private
    # 支持在views/:controller 目录下，用 _action 开头的子目录进一步分组，会优先查找该目录下文件
    def _prefixes
      _action_name = (request&.params || {})['action']
      pres = ["#{controller_path}/_#{_action_name}", "#{controller_path}/_base"]

      _super_class = self.class.superclass
      while _super_class.action_methods.include?(_action_name)
        pres = pres + ["#{_super_class.controller_path}/_#{_action_name}", "#{_super_class.controller_path}/_base"]
        _super_class = _super_class.superclass
      end
      pres = pres + super

      if defined?(current_organ) && current_organ&.code.present?
        RailsExtend.config.override_prefixes.each do |pre|
          index = pres.index(pre)
          pres.insert(index, "#{current_organ.code}/views/#{pre}") if index
        end
        pres.prepend "#{current_organ.code}/views/#{controller_path}"
      end

      pres
    end

  end
end

ActiveSupport.on_load :action_controller do
  prepend RailsExtend::ActionController::Prepend
end

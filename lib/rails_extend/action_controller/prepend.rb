module RailsExtend::ActionController
  module Prepend

    private
    def _prefixes
      # 支持在 views/:controller 目录下以 _:action 开头的子目录进一步分组，会优先查找该目录下文件
      # 支持在 views/:controller 目录下以 _base 开头的通用分组子目录
      pres = ["#{controller_path}/_#{params['action']}", "#{controller_path}/_base"]
      names = [params[:namespace]]

      super_class = self.class.superclass
      # 同名 controller, 向上级追溯
      while RailsExtend::Routes.find_actions(super_class.controller_path).include?(params['action'])
        pres.concat ["#{super_class.controller_path}/_#{params['action']}", "#{super_class.controller_path}/_base"]
        names.append RailsExtend::Routes.controller_paths.dig(super_class.controller_path, :namespace)
        super_class = super_class.superclass
      end
      # 可以在 controller 中定义 _prefixes 方法
      # super do |pres|
      #   pres + ['xx']
      # end
      if block_given?
        pres = yield pres
      end
      pres += super

      names.compact_blank!
      if names.size >= 2
        names[0...-1].zip(names[1..-1]).each do |before, after|
          if params[:business]
            base_con = "#{params[:business]}/#{before}/base"
            if pres.exclude?(base_con)
              r = pres.find_index(&->(i){ i == "#{params[:business]}/#{after}/base" })
              pres.insert(r, base_con) if r
            end
          end

          if pres.exclude?(before)
            r = pres.find_index(&->(i){ i == after })
            pres.insert(r, before) if r
          end
        end
      end

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

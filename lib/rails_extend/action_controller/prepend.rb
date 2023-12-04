module RailsExtend::ActionController
  module Prepend

    private
    def _prefixes
      # 支持在 views/:controller 目录下以 _:action 开头的子目录进一步分组，会优先查找该目录下文件
      # 支持在 views/:controller 目录下以 _base 开头的通用分组子目录
      pres = ["#{controller_path}/_#{params['action']}"]
      names = ["#{controller_path}"]

      super_class = self.class.superclass
      # 同名 controller, 向上级追溯
      while RailsExtend::Routes.find_actions(super_class.controller_path).include?(params['action'])
        pres.append "#{super_class.controller_path}/_#{params['action']}"
        names.append "#{super_class.controller_path}"
        super_class = super_class.superclass
      end

      pres.concat names.map(&->(i){ "#{i}/_base" })
      # 可以在 controller 中定义 _prefixes 方法
      # super do |pres|
      #   pres + ['xx']
      # end
      if block_given?
        pres = yield pres
      end
      pres += super

      r = names.map do |i|
        olds = i.split('/')
        olds[-1] = 'base'
        olds.join('/')
      end
      r_index = pres.index(r[-1])
      pres.insert(r_index, *r[0..-2]) if r_index

      # layout
      layout_index = pres.index(&->(i){ i.exclude?('/') })
      pres.insert(layout_index, self.class._layout) if layout_index && self.class._layout.is_a?(String)

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

ActiveSupport.on_load :action_controller_base do
  prepend RailsExtend::ActionController::Prepend
end

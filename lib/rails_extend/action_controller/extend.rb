module RailsExtend::ActionController
  module Extend

    # if whether_filter(:require_user)
    #   skip_before_action :require_user
    # end
    def whether_filter(filter)
      self.get_callbacks(:process_action).map(&:filter).include?(filter.to_sym)
    end

    def raw_view_paths
      view_paths.paths.map { |i| i.path }
    end

    def super_controllers(root = ApplicationController)
      r = ancestors.select(&->(i){ i.is_a?(Class) })
      r[1..r.index(root)]
    end

  end
end

ActiveSupport.on_load :action_controller do
  extend RailsExtend::ActionController::Extend
end

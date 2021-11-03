module RailsExtend::ActionController
  module Extend

    # if whether_filter(:require_login)
    #   skip_before_action :require_login
    # end
    def whether_filter(filter)
      self.get_callbacks(:process_action).map(&:filter).include?(filter.to_sym)
    end

    def raw_view_paths
      view_paths.paths.map { |i| i.path }
    end

  end
end

ActiveSupport.on_load :action_controller do
  extend RailsExtend::ActionController::Extend
end

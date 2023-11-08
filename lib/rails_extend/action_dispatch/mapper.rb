module RailsExtend::ActionDispatch
  module Mapper

    def set_member_mappings_for_resource
      new do
        post :new
      end if parent_resource.actions.include?(:new)
      member do
        post :actions
        post :show if parent_resource.actions.include?(:show)
        post :edit if parent_resource.actions.include?(:edit)
      end
      super
    end

  end
end


ActionDispatch::Routing::Mapper.prepend RailsExtend::ActionDispatch::Mapper

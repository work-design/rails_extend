module RailsExtend::ActionDispatch
  module Mapper

    def set_member_mappings_for_resource
      member do
        post :actions
      end
      super
    end

  end
end


ActionDispatch::Routing::Mapper.prepend RailsExtend::ActionDispatch::Mapper

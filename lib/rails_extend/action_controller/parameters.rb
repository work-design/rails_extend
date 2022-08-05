module RailsExtend::ActionController
  module Parameters

    def to_meta
      except(:business, :namespace).permit!.transform_keys!(&->(i){ ['controller', 'action'].include?(i) ? "meta_#{i}" : i }).to_h
    end

  end
end

ActionController::Parameters.prepend RailsExtend::ActionController::Parameters

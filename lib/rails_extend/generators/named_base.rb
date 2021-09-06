# frozen_string_literal: true

require 'rails/generators'
module RailsExtend::Generators
  module NamedBase

    def class_name
      file_name.classify
    end

    def singular_route_name
      [class_path[-1], singular_name].join('_')
    end

    def plural_route_name
      [class_path[-1], plural_name].join('_')
    end

  end
end

Rails::Generators::NamedBase.prepend RailsExtend::Generators::NamedBase

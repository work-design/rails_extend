require_relative 'yaml'
require 'active_support/core_ext/pathname/existence'

module RailsExtend
  module Exporter
    extend self

    def export
      vite = Yaml.new(template: 'config/template.yml', export: 'config/vite.yml')

      vite.append 'entry_paths', Rails.root.join('app/views').to_s
      vite.append 'entry_paths', Rails.root.join('app/entrypoints').to_s
      Rails::Engine.subclasses.each do |engine|
        view_root = engine.root.join('app/views')
        if view_root.directory?
          vite.append 'entry_paths', view_root.to_s
        end

        entrypoint_root = engine.root.join('app/assets', 'entrypoints')
        if entrypoint_root.directory?
          vite.append 'entry_paths', entrypoint_root.to_s
        end
      end

      vite.dump
    end

  end
end

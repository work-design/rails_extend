require_relative 'yaml'
require 'active_support/core_ext/pathname/existence'

module RailsExtend
  module Exporter
    extend self

    def export
      vite = Yaml.new(template: 'config/template.yml', export: 'config/vite.yml')

      Rails::Engine.subclasses.each do |engine|
        view_root = engine.root.join('app/assets', 'stylesheets')
        if view_root.directory?
          vite.append 'entry_paths', view_root.to_s
        end

        entrypoint_root = engine.root.join('app/assets', 'entrypoints')
        if entrypoint_root.directory?
          vite.append 'entry_paths', entrypoint_root.to_s
        end

        if engine.root.join('yarn.lock').exist? && view_root.directory?
          Dir.chdir engine.root do
            $stdout.puts "\e[35m  install \e[0m #{engine.root}"
            system 'yarn install'
          end
          vite.append 'entry_paths', engine.root.join('node_modules').to_s
        end
      end

      vite.dump
    end

  end
end

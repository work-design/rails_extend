module RailsExtend
  module Generators
    class IgnoreGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      attr_reader :ignore_models

      def copy_initializer_file
        puts "#{'*-' * 40}"
        Models.ignore_models.each do |count, models|
          puts "#{count.to_s.rjust(2, ' ')}: #{models.inspect}"
        end
        puts "#{'*-' * 40}"

        limit = args[0].to_i
        @ignore_models = Models.ignore_models.select(&->(k, v){ k <= limit })

        template 'initializer.rb', 'config/initializers/rails_extend.rb'
      end

      def show_readme
        if behavior == :invoke
          readme 'README.md'
        end
      end
    end
  end
end

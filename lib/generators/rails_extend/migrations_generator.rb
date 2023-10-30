# frozen_string_literal: true
# bin/rails g rails_com:migrations
require 'rails/generators/active_record/migration'

class RailsExtend::MigrationsGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration
  source_root File.expand_path('templates', __dir__)
  attr_reader :tables

  def create_migration_file
    file_name = "smart_migration_#{file_index}"

    RailsExtend::Models.db_tables_hash.each do |mig_paths, tables|
      next if tables.blank?
      @tables = tables
      path = Array(mig_paths)[0]
      migration_template 'migration.rb', File.join(path, "#{file_name}.rb")
    end
  end

  def file_index
    ups = ActiveRecord::Base.connection.migration_context.migrations_status.select do |status, version, name|
      status == 'up' && name.start_with?('Smart migration ')
    end
    if ups.present?
      index = ups[-1][-1].delete_prefix 'Smart migration '
      index.to_i + 1
    else
      1
    end
  end

end

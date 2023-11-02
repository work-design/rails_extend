# frozen_string_literal: true
# bin/rails g rails_com:rename_module new old
require 'rails/generators/active_record/migration'

class RailsExtend::RemoveTableGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration
  source_root File.expand_path('templates', __dir__)
  attr_reader :tables

  def create_migration_file
    @tables = RailsExtend::Models.unbound_tables
    file_name = "smart_remove_table_#{file_index}"

    migration_template 'remove_table.rb', File.join(db_migrate_path, "#{file_name}.rb")
  end

  def file_index
    ups = ActiveRecord::Base.connection.migration_context.migrations_status.select do |status, version, name|
      status == 'up' && name.start_with?('Smart remove table ')
    end
    if ups.present?
      index = ups[-1][-1].delete_prefix 'Smart remove table '
      index.to_i + 1
    else
      1
    end
  end

end

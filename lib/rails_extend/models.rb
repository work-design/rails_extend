module RailsExtend::Models
  extend self

  def models_hash(root = ActiveRecord::Base)
    return @models_hash if defined? @models_hash
    Zeitwerk::Loader.eager_load_all
    @models_hash = root.subclasses_tree
  end

  def models
    return @models if defined? @models
    Zeitwerk::Loader.eager_load_all
    @models = ActiveRecord::Base.descendants
    @models.reject!(&:abstract_class?)
    @models
  end

  def db_tables_hash
    result = {}

    models.group_by(&->(i) { i.connection.migrations_paths }).each do |migrations_paths, record_classes|
      result[migrations_paths] = migrate_tables_hash(record_classes)
    end

    result
  end

  def tables_hash(root = ActiveRecord::Base, records_hash = models_hash)
    @tables ||= {}

    records_hash[root].each_key do |node|
      next if RailsExtend.config.ignore_models.include?(node.to_s)
      unless node.abstract_class?
      # records.group_by(&:table_name).each do |table_name, record_classes|

        @tables[node.table_name] ||= {}
        r = @tables[node.table_name]
        r[:models] ||= []
        r[:models] << node

        r[:table_exists] = r[:table_exists] || node.table_exists?

        r[:model_attributes] ||= {}
        r[:model_attributes].reverse_merge! node.migrate_attributes_by_model

        r[:model_references] ||= {}
        r[:model_references].reverse_merge! node.references_by_model

        r[:indexes] ||= []
        r[:indexes] += node.indexes_by_model
      end

      tables_hash(node, records_hash[root])
    end

    @tables
  end

  def migrate_tables_hash
    tables = {}

    tables_hash.each do |table_name, cols|
      db = cols['models'][0].migrate_attributes_by_db

      r[:add_attributes] = cols[:model_attributes].except! db.keys
      r[:add_references] = cols[:model_references].except! db.keys
      r[:timestamps] = ['created_at', 'updated_at'] & r[:add_attributes].keys
      r[:remove_attributes] = db.except!(*r[:model_attributes].keys, *record_class.attributes_by_belongs.keys, *record_class.attributes_by_default)

      tables[table_name] = r unless r[:add_attributes].blank? && r[:add_references].blank? && r[:remove_attributes].blank?
    end

    tables
  end

  def migrate_modules_hash
    @modules = {}

    models.group_by(&:module_parent).each do |module_name, record_classes|
      new_prefix = (module_name.respond_to?(:table_name_prefix) && module_name.table_name_prefix) || ''
      old_prefix = (module_name.respond_to?(:old_table_name_prefix) && module_name.old_table_name_prefix) || ''

      record_classes.each do |record_class|
        unless record_class.table_exists?
          possible = record_class.table_name.sub(/^#{new_prefix}/, old_prefix)
          @modules.merge! record_class.table_name => possible if tables.any?(possible)
        end
      end
    end

    arr = @modules.values
    result = arr.find_all { |e| arr.rindex(e) != arr.index(e) }
    warn "Please check #{result}"

    @modules
  end

  def unbound_tables
    tables - models.map(&:table_name) - ['schema_migrations', 'ar_internal_metadata']
  end

  def ignore_models
    models.group_by(&->(i){ i.attributes_to_define_after_schema_loads.size }).transform_values!(&->(i) { i.map(&:to_s) })
  end

  def tables
    ActiveRecord::Base.connection.tables
  end

  def model_names
    models.map(&:to_s)
  end

end

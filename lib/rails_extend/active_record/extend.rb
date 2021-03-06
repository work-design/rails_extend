module RailsExtend::ActiveRecord
  module Extend

    def human_name
      model_name.human
    end

    def subclasses_tree(tree = {}, node = self)
      tree[node] ||= {}

      node.subclasses.each do |subclass|
        tree[node].merge! subclasses_tree(tree[node], subclass)
      end

      tree
    end

    def to_fixture
      require 'rails/generators/test_unit/model/model_generator'

      args = [
        self.name.underscore
      ]
      cols = columns.reject(&->(i){ attributes_by_default.include?(i.name) }).map { |col| "#{col.name}:#{col.type}" }

      generator = TestUnit::Generators::ModelGenerator.new(args + cols, destination_root: Rails.root, fixture: true)
      generator.instance_variable_set :@source_paths, Array(RailsExtend::Engine.root.join('lib/templates', 'test_unit/model'))
      generator.invoke_all
    end

    def com_column_names
      column_names - attributes_by_default + attachment_reflections.select(&->(_, i){ i.macro == :has_one_attached }).keys
    end

    def com_column_hash
      attaches = attachment_reflections.select(&->(_, i){ i.macro == :has_many_attached })
      attaches.transform_values!(&->(_){ [] })
    end

    def column_attributes
      columns.map do |column|
        r = {
          name: column.name.to_sym,
          type: column.type
        }
        r.merge! null: column.null unless column.null
        r.merge! default: column.default unless column.default.nil?
        r.merge! comment: column.comment if column.comment.present?
        r.merge! column.sql_type_metadata.instance_values.slice('limit', 'precision', 'scale').compact
        r.symbolize_keys!
      end
    end

    def attributes_by_model
      cols = {}

      attributes_to_define_after_schema_loads.each do |name, column|
        r = {}
        r.merge! type: column[0]

        if r[:type].respond_to? :call
          r.merge! type: r[:type].call(ActiveModel::Type::String.new)
        end

        if r[:type].respond_to?(:type)
          r.merge! raw_type: r[:type].type
        else
          r.merge! raw_type: r[:type] # ?????? rails 7 ??????
        end

        case r[:type].class.name
        when 'ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Array'
          r.merge! array: true
        when 'ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Range'
          r.merge! range: true
        end

        if r[:type].respond_to?(:options) && r[:type].options.present?
          r.merge! r[:type].options
        end

        if Rails::VERSION::MAJOR >= 7 && !column[1].instance_of?(Object) # Rails 7, column[1] ????????????
          r.merge! default: column[1]
        elsif Rails::VERSION::MAJOR < 7 # rails 7 ??????, column[1] ??? options
          r.merge! column[1]
        end

        cols.merge! name => r
      end

      cols
    end

    def migrate_attributes_by_model
      cols = {}
      attributes_by_model.each do |name, column|
        r = {}
        r.merge! column
        r.merge! migrate_type: column[:raw_type]
        r.symbolize_keys!

        if r[:type].respond_to? :migrate_type
          r.merge! migrate_type: r[:type].migrate_type
        end

        if r[:default].respond_to?(:call)
          r.delete(:default)
        end

        if r[:array] && connection.adapter_name != 'PostgreSQL'
          r.delete(:array)
          r[:migrate_type] = :json
          r.delete(:default) if r[:default].is_a? Array
        end

        if r[:migrate_type] == :json
          if connection.adapter_name == 'PostgreSQL' # Postgres ?????? json ??? jsonb
            r[:migrate_type] = :jsonb
          else
            r.delete(:default) # mysql ????????????????????? json ????????????
          end
        end

        if r[:migrate_type] == :jsonb && connection.adapter_name != 'PostgreSQL'
          r[:migrate_type] == :json
          r.delete(:default)
        end

        r.merge! attribute_options: r.slice(:limit, :precision, :scale, :null, :index, :array, :range, :size, :default, :comment).inject('') { |s, h| s << ", #{h[0]}: #{h[1].inspect}" }

        cols.merge! name.to_sym => r
      end

      cols
    end

    def migrate_attributes_by_db
      return {} unless table_exists?
      cols = {}

      columns_hash.each do |name, column|
        r = { type: column.type }
        r.merge! migrate_type: r[:type]
        r.merge! null: column.null unless column.null
        r.merge! default: column.default unless column.default.nil?
        r.merge! comment: column.comment if column.comment.present?
        r.merge! column.sql_type_metadata.instance_values.slice('limit', 'precision', 'scale').compact
        r.symbolize_keys!
        r.merge! attribute_options: r.slice(:limit, :precision, :scale, :null, :index, :array, :size, :default, :comment).inject('') { |s, h| s << ", #{h[0]}: #{h[1].inspect}" }

        cols.merge! name.to_sym => r
      end

      cols
    end

    def attributes_by_default
      if table_exists?
        [primary_key.to_sym] + all_timestamp_attributes_in_model.map(&:to_sym)
      else
        []
      end
    end

    def attributes_by_belongs
      results = {}

      reflections.values.select(&->(reflection){ reflection.belongs_to? }).each do |reflection|
        results.merge! reflection.foreign_key.to_sym => {
          input_type: :integer  # todo ?????? foreign_key ???????????? ID ?????????
        }
        results.merge! reflection.foreign_type.to_sym => { input_type: :string } if reflection.foreign_type
      end
      results.except! *attributes_by_model.keys.map(&:to_s)

      results
    end

    def references_by_model
      results = {}
      refs = reflections.values.select(&->(reflection){ reflection.belongs_to? })
      refs.reject! { |reflection| reflection.foreign_key.to_s != "#{reflection.name}_id" }
      refs.reject! { |reflection| attributes_to_define_after_schema_loads.key?(reflection.foreign_key) }
      refs.each do |ref|
        r = { name: ref.name }
        r.merge! polymorphic: true if ref.polymorphic?
        r.merge! reference_options: r.slice(:polymorphic).inject('') { |s, h| s << ", #{h[0]}: #{h[1].inspect}" }
        results[ref.foreign_key.to_sym] = r unless results.key?(ref.foreign_key.to_sym)
      end

      results
    end

    def indexes_by_model
      indexes = indexes_to_define_after_schema_loads
      indexes.map! do |index|
        index.merge! index_options: index.slice(:unique, :name).inject('') { |s, h| s << ", #{h[0]}: #{h[1].inspect}" }
      end
    end

  end
end

ActiveSupport.on_load :active_record do
  extend RailsExtend::ActiveRecord::Extend
end

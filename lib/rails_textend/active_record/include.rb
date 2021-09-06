module RailsExtend::ActiveRecord
  module Include
    extend ActiveSupport::Concern

    included do
      class_attribute :indexes_to_define_after_schema_loads, instance_accessor: false, default: []
    end

    def error_text
      errors.full_messages.join("\n")
    end

    def class_name
      self.class.base_class.name
    end

    def attributes_with_type(except: ['id', 'created_at', 'updated_at'], only: [])
      cols = {}
      if only.present?
        columns = attributes.slice(*only)
      else
        columns = attributes.except(*except)
      end

      columns.each do |key, value|
        type = self.class.input_attributes_by_model[key] || self.class.attributes_by_belongs[key]
        r = {}
        r.merge! value: value, input_type: type[:input_type], **DefaultForm.config.mapping.fetch(type[:input_type], {})
        r.merge! outer: type[:outer] if type.key? :outer
        cols.merge! key => r
      end

      cols
    end

    def as_full_json
      as_json(include: _reflections.keys)
    end

    class_methods do
      def index(name, **options)
        h = { index: name, **options }
        self.indexes_to_define_after_schema_loads = self.indexes_to_define_after_schema_loads + [h]
      end
    end

  end
end

ActiveSupport.on_load :active_record do
  include RailsExtend::ActiveRecord::Include
end

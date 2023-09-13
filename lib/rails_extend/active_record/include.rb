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

    def pretty_print(pp)
      return super if custom_inspect_method_defined?
      pp.object_address_group(self) do
        if defined?(@attributes) && @attributes
          attr_names = self.class.attribute_names.select { |name| _has_attribute?(name) }
          max_indent = attr_names.map(&:length).max
          pp.seplist(attr_names, proc { pp.text "," }) do |attr_name|
            pp.breakable " "
            pp.group(1) do
              pp.text attr_name.rjust(max_indent)
              pp.text ":"
              pp.breakable
              value = _read_attribute(attr_name)
              value = inspection_filter.filter_param(attr_name, value) unless value.nil?
              pp.pp value
            end
          end
        else
          pp.breakable " "
          pp.text "not initialized"
        end
      end
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

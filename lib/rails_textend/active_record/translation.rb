# frozen_string_literal: true

module RailsExtend::ActiveRecord
  module Translation

    # name
    # * store as jsonb in database;
    # * read with i18n scope
    def has_translations(*columns)
      mattr_accessor :i18n_attributes
      self.i18n_attributes = columns.map(&:to_s)
      include RailsCom::I18n
      columns.each do |column|
        attribute column, :i18n

        class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
  
          def #{column}=(value)
            if value.is_a?(String)
              super(::I18n.locale.to_s => value)
            else
              super
            end
          end

        RUBY_EVAL
      end

    end

    def _update_record(values, constraints)
      values.except!(*i18n_attributes) if self.respond_to?(:i18n_attributes)
      super
    end

  end
end

ActiveSupport.on_load :active_record do
  extend RailsExtend::ActiveRecord::Translation
end

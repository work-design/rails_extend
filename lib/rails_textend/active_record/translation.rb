# frozen_string_literal: true

module RailsCom::I18n
  extend ActiveSupport::Concern

  included do
    before_update :update_i18n_column
  end

  def update_i18n_column
    str = []
    self.changes.slice(*i18n_attributes).each do |key, _|
      value = self.public_send("#{key}_before_type_cast")
      str << "#{key} = #{key}::jsonb || '#{value.to_json}'::jsonb"
    end
    return if str.blank?
    s = str.join(', ')
    self.class.connection.execute "UPDATE #{self.class.table_name} SET #{s} WHERE id = #{self.id}"
  end

  def attributes_with_values_for_create(attribute_names)
    r = super
    r.slice(*i18n_attributes).each do |key, v|
      r[key] = public_send "#{key}_before_type_cast"
    end
    r
  end

end

module RailsCom::Translation

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

ActiveSupport.on_load :active_record do
  extend RailsCom::Translation
end

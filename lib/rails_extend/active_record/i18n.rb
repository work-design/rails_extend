# frozen_string_literal: true

module RailsExtend::ActiveRecord
  module I18n
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
end

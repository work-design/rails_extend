# frozen_string_literal: true

module RailsExtend::ActiveRecord
  module Taxon

    def has_taxons(*columns)
      columns.each do |column|
        attribute "#{column}_ancestors", :taxon, outer: column
        class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
          before_validation :sync_#{column}_id, if: -> { #{column}_ancestors_changed? }
  
          def sync_#{column}_id
            _outer_id = Hash(#{column}_ancestors).values.compact.last
            if _outer_id
              self.#{column}_id = _outer_id
            else
              self.#{column}_id = nil
            end
          end
        RUBY_EVAL
      end
    end

  end
end

ActiveSupport.on_load :active_record do
  extend RailsExtend::ActiveRecord::Taxon
end

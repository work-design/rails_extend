# frozen_string_literal: true

module RailsExtend::ActiveStorage
  module Variant
    extend ActiveSupport::Concern

    included do
      attribute :variation_digest, :string, null: false
    end

  end
end

ActiveSupport.on_load(:active_storage_blob) do
  ActiveStorage::VariantRecord.include RailsExtend::ActiveStorage::Variant
end

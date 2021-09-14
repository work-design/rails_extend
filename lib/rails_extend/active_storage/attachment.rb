# frozen_string_literal: true

module RailsExtend::ActiveStorage
  module Attachment
    extend ActiveSupport::Concern

    included do
      attribute :name, :string, null: false
    end

  end
end

ActiveSupport.on_load(:active_storage_blob) do
  ActiveStorage::VariantRecord.include RailsExtend::ActiveStorage::Attachment
end

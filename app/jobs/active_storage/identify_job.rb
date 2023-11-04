# frozen_string_literal: true

class ActiveStorage::IdentifyJob < ActiveStorage::BaseJob

  def perform(blob)
    blob.identify
  end

end

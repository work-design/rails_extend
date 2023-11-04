module RailsExtend::ActiveStorage
  module AttachmentPrepend

    def identify_blob
      if record.respond_to? "sync_#{name}"
        record.send "sync_#{name}"
      end
    end

  end
end

ActiveSupport.on_load(:active_storage_attachment) do
  prepend RailsExtend::ActiveStorage::AttachmentPrepend
end

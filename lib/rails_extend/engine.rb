# frozen_string_literal: true

module RailsExtend
  class Engine < ::Rails::Engine #:nodoc:

    initializer 'rails_extend.quiet_logs' do |app|
      if RailsExtend.config.quiet_logs.present?
        app.middleware.insert_before ::Rails::Rack::Logger, ::RailsExtend::QuietLogs
      end
    end

  end
end

# frozen_string_literal: true

require 'active_support/configurable'

module RailsExtend #:nodoc:
  include ActiveSupport::Configurable

  configure do |config|
    config.enum_key = ->(o, attribute){ "#{o.i18n_scope}.enum.#{o.base_class.model_name.i18n_key}.#{attribute}" }
    config.help_key = ->(o, attribute){ "#{o.i18n_scope}.help.#{o.base_class.model_name.i18n_key}.#{attribute}" }
    config.ignore_models = [
      'GoodJob::BaseExecution',
      'GoodJob::BatchRecord',
      'GoodJob::DiscreteExecution',
      'GoodJob::Execution',
      'GoodJob::Job',
      'GoodJob::Process',
      'GoodJob::Setting'
    ]
    config.override_prefixes = [
      'application'
    ]
    config.quiet_logs = [
      '/rails/active_storage',
      '/images',
      '/@fs'
    ]
  end

end

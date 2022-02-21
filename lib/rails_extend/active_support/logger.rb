module RailsExtend::ActiveSupport
  module Logger

    def local_level
      Thread.current[:logger_thread_safe_level] || super
    end

    def local_level=(level)
      super

      Thread.current[:logger_thread_safe_level] = ::ActiveSupport::IsolatedExecutionState[:logger_thread_safe_level]
    end

  end
end

ActiveSupport::Logger.prepend RailsExtend::ActiveSupport::Logger

require 'reline'
module RailsExtend
  class QuietLogs

    def initialize(app)
      @app = app
      @assets_regex = %r(\A/{0,2}(#{RailsExtend.config.quiet_logs.join('|')}))
    end

    def call(env)
      if env['PATH_INFO'] =~ @assets_regex
        Rails.logger.debug "\e[33m  Silenced: #{env['PATH_INFO']}  \e[0m"
        Rails.logger.silence { @app.call(env) }
      else
        unless Rails.env.development?
          Rails.logger.debug "\e[33m #{'-' * screen_width} \e[0m"
        end
        @app.call(env)
      end
    end

    def screen_width
      Reline.get_screen_size.last - 2
    rescue Errno::EINVAL # in `winsize': Invalid argument - <STDIN>
      79
    end

  end
end

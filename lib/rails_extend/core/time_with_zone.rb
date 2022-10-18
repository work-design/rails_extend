require 'rails_extend/core/date_and_time'

module ActiveSupport
  class TimeWithZone
    include RailsExtend::DateAndTime

    def inspect
      to_s
    end

  end
end

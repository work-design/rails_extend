module RailsExtend
  module DateAndTime

    # 用于 change 方法
    def parts
      {
        year: year,
        month: month,
        day: day,
        hour: hour,
        min: min,
        sec: sec,
        offset: formatted_offset
      }
    end

  end
end

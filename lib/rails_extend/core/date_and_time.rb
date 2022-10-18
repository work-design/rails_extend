module RailsExtend
  module DateAndTime

    # 用于 change 方法
    def parts
      arr = to_a
      {
        sec: arr[0],
        min: arr[1],
        hour: arr[2],
        day: arr[3],
        month: arr[4],
        year: arr[5],
        offset: arr[-1]
      }
    end

  end
end

module RailsExtend
  module DateAndTime

    def parts
      arr = to_a
      {
        seconds: arr[0],
        minutes: arr[1],
        hours: arr[2],
        days: arr[3],
        months: arr[4],
        years: arr[5]
      }
    end

  end
end

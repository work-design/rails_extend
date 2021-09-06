# frozen_string_literal: true

class Array

  #   arr = [1, 2, 3]
  #   arr.ljust! 5, nil
  #   # => [nil, nil, 1, 2, 3]
  def ljust!(n, x)
    return self if n < length
    insert(0, *Array.new([0, n-length].max, x))
  end

  # fill an array with the given elements left;
  #   arr = [1, 2, 3]
  #   arr.rjust! 5, nil
  #   # => [1, 2, 3, nil, nil]
  def rjust!(n, x)
    return self if n < length
    fill(x, length...n)
  end

  ##
  #   arr = [1, 2, 3]
  #   arr.mjust!(5, nil)
  #   # => [1, 2, nil, nil, 3]
  def mjust!(n, x)
    return self if n < length
    insert((length / 2.0).ceil, *Array.new(n - length, x))
  end

  ##
  # combine the same key hash like array
  #   raw_data = [
  #     { a: 1 },
  #     { a: 2 },
  #     { b: 2 },
  #     { b: 2 }
  #   ]
  #   raw_data.to_combine_h
  #   #=> { a: [1, 2], b: 2 }
  def to_combine_h
    self.inject({}) do |memo, obj|
      memo.merge(obj) do |_, old_val, new_val|
        v = (Array(old_val) + Array(new_val)).uniq
        v.size > 1 ? v : v[0]
      end
    end
  end

  #
  # raw_data = [
  #   [:a, 1],
  #   [:a, 2, 3],
  #   [:b, 2]
  # ]
  # raw_data.to_array_h
  # #=> [ { a: 1 }, { a: 2 }, { b: 2 } ]
  def to_array_h
    self.map { |x, y| { x => y } }
  end

  # 2D array to csv file
  #   data = [
  #     [1, 2],
  #     [3, 4]
  #   ]
  #   data.to_csv_file
  def to_csv_file(file = 'export.csv')
    CSV.open(file, 'w') do |csv|
      self.each { |ar| csv << ar }
    end
  end

  # 比较两个数组忽略排序的情况下是否相等
  def compare(other)
    (self - other).empty? && (other - self).empty?
  end

end

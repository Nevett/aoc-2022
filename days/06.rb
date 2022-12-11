class Day06 < Day
  def part_1
    check(4)
  end
  
  def part_2
    check(14)
  end

  private def check(window_size)
    (0..input.length - window_size).each do |i|
      end_pos = i + window_size
      return end_pos if input[Range.new(i, end_pos, true)].chars.uniq.length == window_size
    end
  end
end

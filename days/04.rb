class Day04 < Day
  def part_1
    contained_count = 0
    range_pairs.each do |first, second|
      contained_count += 1 if first.cover?(second) || second.cover?(first)
    end
    contained_count
  end

  def part_2
    overlap_count = 0
    range_pairs.each do |first, second|
      overlap_count += 1 if first.cover?(second.begin) || second.cover?(first.begin)
    end
    overlap_count
  end

  private def range_pairs
    input.lines.map do |line|
      line.split(',').map do |range|
        range_start, range_end = range.split('-').map(&:to_i)
        Range.new(range_start, range_end)
      end
    end
  end
end

class Day01 < Day
  def part_1
    calorie_counts.max
  end

  def part_2
    calorie_counts.sort.last(3).sum
  end

  def calorie_counts
    acc = 0
    calorie_counts = []
    stripped_input_lines.each do |line|
      line = line.strip
      if line.empty?
        calorie_counts << acc
        acc = 0
      else
        acc += line.to_i
      end
    end

    calorie_counts << acc

    calorie_counts
  end
end

class Day03 < Day
  def part_1
    input.lines.sum do |line|
      half_1, half_2 = line.chars.map { |item| priority(item) }.each_slice(line.length / 2).map(&:to_a)
      (half_1 & half_2).sum
    end
  end

  def part_2
    total = 0
    input.lines.each_slice(3) do |group|
      group_priorities = group.map { |rucksack| rucksack.chars.map { |item| priority(item) } }
      total += group_priorities.reduce(:&).sum
    end
    total
  end

  private def priority(item)
    ord = item.ord
    return ord - 96 if ord >= 97
    ord - 38
  end
end

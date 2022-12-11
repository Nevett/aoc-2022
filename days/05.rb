require 'json'

class Day05 < Day
  MOVE_REGEX = /move (\d+) from (\d+) to (\d+)/
  
  def part_1
    stacks = initial_stacks

    moves.each do |move|
      _, count, from, to = MOVE_REGEX.match(move).to_a.map(&:to_i)
      count.times do
        stacks[to-1].push(stacks[from-1].pop)
      end
    end

    stacks.map(&:last).join
  end

  def part_2
    stacks = initial_stacks

    moves.each do |move|
      _, count, from, to = MOVE_REGEX.match(move).to_a.map(&:to_i)
      crates = stacks[from-1].pop(count)
      stacks[to-1].push(*crates)
    end

    stacks.map(&:last).join
  end

  private def moves
    input.lines[moves_start..]
  end

  private def moves_start
    input.lines.find_index { |line| line.start_with?('move') }
  end

  private def initial_layout
    input.lines[0..(moves_start-3)].map do |layout_line|
      layout_line.chars.each_slice(4).map { |x| x[1] }
    end
  end

  private def initial_stacks
    stacks = Array.new(initial_layout.last.length) {Array.new}	
  
    initial_layout.reverse.each do |values|
      values.each_with_index do |value, index|
        stacks[index].push(value) unless value.strip.empty?
      end
    end

    stacks
  end
end

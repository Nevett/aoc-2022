class Day08 < Day
  def part_1
    visible_count = (2 * w + 2 * h) - 4

    iterate_grid_interior do |tree_h, grid_lines|

      visible = grid_lines.any? do |line|
        line.all? { |n| n < tree_h }
      end

      visible_count += 1 if visible
    end

    visible_count
  end

  def part_2
    max_scenic_score = 0

    iterate_grid_interior do |tree_h, grid_lines|
      score = grid_lines
        .map { |line| dir_score(line, tree_h) }
        .reduce(:*)

      max_scenic_score = score if score > max_scenic_score
    end

    max_scenic_score
  end

  private def iterate_grid_interior
    (1..w-2).each do |x|
      (1..h-2).each do |y|
        tree_h = grid[y][x]

        grid_lines = [
          grid[0..y-1].map { |n| n[x] }.reverse,
          grid[y+1..].map { |n| n[x] },
          grid[y][x+1..],
          grid[y][0..x-1].reverse
        ]

        yield tree_h, grid_lines
      end
    end
  end

  private def dir_score(direction_trees, tree_h)
    visible = direction_trees.take_while { |i| i < tree_h }

    score = visible.length
    score += 1 unless visible.length == direction_trees.length

    score
  end

  private def grid
    @grid ||= input.lines.map { |l| l.chars.map(&:to_i) }
  end

  private def w
    @w ||= grid[0].length
  end

  private def h
    @h ||= grid.length
  end
end

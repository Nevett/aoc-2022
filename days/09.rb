class Day09 < Day
  def part_1
    head = Position.new
    tail = Position.new

    visited_positions = Set.new()
    visited_positions.add(tail)

    movements.each do |direction|
      head = head.move(direction: direction)
      tail = tail.follow(head)
      visited_positions.add(tail)
    end

    visited_positions.count
  end

  def part_2
    head = Position.new
    rope = Array.new(10) { Position.new }

    visited_positions = Set.new()
    visited_positions.add(rope.last)

    movements.each do |direction|
      rope[0] = rope[0].move(direction: direction)

      rope.each_index.drop(1).each do |i|
        rope[i] = rope[i].follow(rope[i-1])
      end

      visited_positions.add(rope.last)
    end

    visited_positions.count
  end

  private def movements
    input.lines.flat_map do |line|
      direction, count = line.split
      Array.new(count.to_i) { direction }
    end
  end

  class Position
    attr_reader :x
    attr_reader :y

    def initialize(x:0,y:0)
      @x = x
      @y = y
    end

    def follow(other)
      d_x = other.x - self.x
      d_y = other.y - self.y

      max_distance = (self.x == other.x || self.y == other.y) ? 1 : 2
      return self if d_x.abs + d_y.abs <= max_distance
      
      dir_x = d_x <=> 0
      dir_y = d_y <=> 0

      if self.x == other.x
        move(x: 0, y: dir_y)
      elsif self.y == other.y
        move(x: dir_x, y: 0)
      else
        move(x: dir_x, y: dir_y)
      end
    end

    def move(x:0,y:0,direction:nil)
      case direction
      when 'U'
        y = -1
      when 'D'
        y = 1
      when 'L'
        x = -1
      when 'R'
        x = 1
      end
      Position.new(x: self.x + x, y: self.y + y)
    end

    def to_s
      "#{x},#{y}"
    end

    def hash
      to_s.hash
    end
  
    def eql?(other)
      self.class == other.class &&
        self.hash == other.hash
    end
    alias :== eql?
  end
end

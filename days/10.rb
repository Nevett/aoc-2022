class Day10 < Day
  def part_1
    signal_strengths = [20, 60, 100, 140, 180, 220].map do |cycle_point|
      x_during_cycle(cycle_point) * cycle_point
    end 
    signal_strengths.sum
  end

  def part_2
    out = ""
    (1..240).map do |cycle|
      sprite_pos = x_during_cycle(cycle)
      sprite_range = (sprite_pos - 1..sprite_pos + 1)
      crt_x = (cycle - 1) % 40
      
      sprite_range.include?(crt_x) ? '█' : ' '
    end.each_slice(40) do |line|
      out += "\n#{line.join}"
    end
    out
  end

  private def x_during_cycle(cycle)
    state_history.filter { |h| h[:consumed] < cycle }.last[:x]
  end

  private def state_history
    return @states if @states

    cycles_consumed = 0
    x_register = 1
    @states = [{ x: x_register, consumed: cycles_consumed }]
    input.lines.each do |instruction|
      case instruction
      when /^noop/
        cycles_consumed += 1
      when /^addx/
        amount = instruction.split.last.to_i
        cycles_consumed += 2
        x_register += amount
      end
      
      @states.push({ x: x_register, consumed: cycles_consumed })
    end
    @states
  end
end

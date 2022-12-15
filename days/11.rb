class Day11 < Day
  def part_1
    monkey_pack = parse_monkeys

    20.times do
      monkey_pack.each { |monkey| monkey.take_turn }
    end

    monkey_pack.map(&:item_inspection_count).sort.last(2).reduce(&:*)
  end

  def part_2
    monkey_pack = parse_monkeys

    10_000.times do
      monkey_pack.each { |monkey| monkey.take_turn(manage_worry: false) }
    end

    monkey_pack.map(&:item_inspection_count).sort.last(2).reduce(&:*)
  end

  private def parse_monkeys
    pack = []
    stripped_input_lines
      .slice_when { |line| line.empty? }
      .each { |monkey_def| Monkey.parse(monkey_def).join(pack) }

    pack
  end

  class Monkey
    def take_turn(manage_worry: true)
      @pack_divisor_product ||= @pack.map(&:test_divisor).uniq.reduce(&:*)

      while item_worry_level = items.shift do
        oper = operand == 'old' ? item_worry_level : operand
        item_worry_level = item_worry_level.public_send(operation, oper)
        
        @item_inspection_count += 1

        if manage_worry
          item_worry_level /= 3
        end

        item_worry_level %= @pack_divisor_product
        
        destination_monkey = item_worry_level % test_divisor == 0 ? true_monkey : false_monkey
        
        @pack[destination_monkey].items.push(item_worry_level)
      end
    end

    def join(pack)
      @pack = pack.push(self)
    end

    def initialize
      @item_inspection_count = 0
    end
    
    def self.parse(definition_lines)
      monkey = Monkey.new

      definition_lines.each do |line|
        if match = line.match(/Starting items:(.+)$/)
          monkey.items = match[1].split(',').map(&:to_i)
        elsif match = line.match(/Operation: new = old (.) (.+)$/)
          monkey.operation = match[1]
          operand = match[2]
          operand = operand.to_i unless operand == 'old'
          monkey.operand = operand
        elsif match = line.match(/Test: divisible by ([0-9]+)$/)
          monkey.test_divisor = match[1].to_i
        elsif match = line.match(/If true: throw to monkey ([0-9]+)$/)
          monkey.true_monkey = match[1].to_i
        elsif match = line.match(/If false: throw to monkey ([0-9]+)$/)
          monkey.false_monkey = match[1].to_i
        end
      end

      monkey
    end

    attr_accessor :items
    attr_reader :item_inspection_count
    attr_accessor :operation
    attr_accessor :operand
    attr_accessor :test_divisor
    attr_accessor :true_monkey
    attr_accessor :false_monkey
  end
end

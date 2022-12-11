require './aoc_helper'
require './day'

day_number = ARGV[0].to_i

raise StandardError, 'Pass day number argument' unless day_number

day_padded = format('%02d', day_number)

require "./days/#{day_padded}"
day_class = Object.const_get("Day#{day_padded}")
day_inst = day_class.new(input: AocHelper.new.input(day_number))

puts "Day #{day_number} part 1: #{day_inst.part_1}"
puts "Day #{day_number} part 2: #{day_inst.part_2}"
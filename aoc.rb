#!/usr/bin/env ruby

require 'dotenv/load'
require './lib/aoc_helper'
require './lib/day'

day_number = ARGV[0].to_i

to_run = [day_number] if (1..25).include?(day_number)

unless to_run
  puts 'Usage aoc.rb day_number'
  puts 'Running all days...'
  to_run = (1..25)
end

runner = AocHelper.new
to_run.each do |day| runner.run(day) end

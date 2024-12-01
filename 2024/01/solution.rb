# frozen_string_literal: true

# input = File.read('input-sample.txt')
input = File.read('input.txt')

lines = input.split("\n").map { _1.split(' ').map(&:strip).map(&:to_i) }
firsts = lines.map(&:first).sort
lasts = lines.map(&:last).sort

puts firsts.zip(lasts).map { (_1 - _2).abs }.sum
puts firsts.map { _1 * lasts.count(_1) }.sum

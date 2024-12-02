# frozen_string_literal: true

def safe?(row)
  diff = row.each_cons(2).map { _2 - _1 }
  first = diff[0]
  diff.all? { _1.abs >= 1 && _1.abs <= 3 && first * _1 >= 0 }
end

# input = File.read('input-sample.txt').lines
input = File.read('input.txt').lines

grid = input.map { _1.split(' ').map(&:to_i) }

puts grid.count { safe?(_1) }
puts(grid.count do |row|
  safe?(row) || 0.upto(row.size - 1).any? { safe?(row[..._1] + row[_1 + 1..]) }
end)

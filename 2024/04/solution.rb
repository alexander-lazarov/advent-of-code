# frozen_string_literal: true

# rubocop:disable Style/GlobalVars
# rubocop:disable Style/ParallelAssignment
# rubocop:disable Naming/MethodParameterName

# input = File.read('input-sample.txt').lines
# input = File.read('input-sample2.txt').lines
input = File.read('input.txt').lines

$grid = input.map { |line| line.strip.split('') }

$dir = [
  [0, 1],
  [0, -1],
  [1, 0],
  [-1, 0],
  [1, 1],
  [1, -1],
  [-1, 1],
  [-1, -1]
]

target = 'XMAS'

def word_at(x, y, dir, length)
  (0...length).map do |i|
    new_x, new_y = x + dir[0] * i, y + dir[1] * i

    next if new_x.negative? || new_x >= $grid.size || new_y.negative? || new_y >= $grid[0].size

    $grid.dig(new_x, new_y)
  end.join
end

def diagonal_letters_at(x, y)
  ([x, y-1], [x, y + 1], [x - 1, y], [x + 1, y]).map do |new_x, new_y|
    $grid.dig(new_x, new_y)
  end.sort
end

puts ((0...$grid.size).map do |x|
  (0...$grid[0].size).map do |y|
    $dir.map { |dir| word_at(x, y, dir, target.size) }
  end
end).flatten.count('XMAS')

puts ((0...$grid.size).map do |x|
  (0...$grid[0].size).map do |y|

  end
end).flatten.count('XMAS')



# rubocop:enable Naming/MethodParameterName
# rubocop:enable Style/ParallelAssignment
# rubocop:enable Style/GlobalVars

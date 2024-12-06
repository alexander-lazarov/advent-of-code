# frozen_string_literal: true

# rubocop:disable Style/GlobalVars
# input = File.read('input-sample.txt').lines
input = File.read('input.txt').lines

$grid = input.map { _1.strip.split('') }
$g = input.map { _1.strip.split('') }

dirs = [
  [-1, 0], # up
  [0, 1], # right
  [1, 0], # down
  [0, -1] # left
]

current = nil
current_dir = 0

visited = Set.new

max_x = $grid.size
max_y = $grid[0].size

ix = nil
iy = nil

max_x.times do |x|
  y = $grid[x].find_index('^')

  next unless y

  ix = x
  iy = y

  $g[x][y] = '.'

  visited.add([x, y])
  current = [x, y]
end

loop do
  current_diff = dirs[current_dir]
  next_x = current[0] + current_diff[0]
  next_y = current[1] + current_diff[1]

  break if next_x.negative? || next_x >= max_x || next_y.negative? || next_y >= max_y

  if $grid[next_x][next_y] == '#'
    current_dir = (current_dir + 1) % 4
  else
    $grid[next_x][next_y] = 'X'
    current = [next_x, next_y]
    visited.add(current)
  end
end

p visited.size

loop_count = 0

(0...max_x).each do |obstacle_x|
  (0...max_y).each do |obstacle_y|
    $g = input.map { _1.strip.split('') }
    next unless $grid[obstacle_x][obstacle_y] == 'X'

    $g[obstacle_x][obstacle_y] = '#'
    current = [ix, iy]
    current_dir = 0
    visited = Set.new

    loop do
      current_diff = dirs[current_dir]
      next_x = current[0] + current_diff[0]
      next_y = current[1] + current_diff[1]

      break if next_x.negative? || next_x >= max_x || next_y.negative? || next_y >= max_y

      if $g[next_x][next_y] == '#'
        current_dir = (current_dir + 1) % 4
      else
        nv = [next_x, next_y, current_dir]
        current = [next_x, next_y]

        if visited.member?(nv)
          loop_count += 1
          break
        end

        visited.add(nv)
      end
    end
  end
end

p loop_count

# rubocop:enable Style/GlobalVars

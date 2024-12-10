# frozen_string_literal: true

# input = File.read('input-sample.txt').lines
input = File.read('input.txt').lines

# rubocop:disable Style/GlobalVars
# rubocop:disable Naming/MethodParameterName

def neighbors(x, y)
  [
    [x - 1, y],
    [x + 1, y],
    [x, y - 1],
    [x, y + 1]
  ].select { |i, j| i >= 0 && j >= 0 && i < $map.size && j < $map[0].size }
end

$map = input.map(&:strip).map { |line| line.split('').map(&:to_i) }

def dfs(x, y, visited = [])
  current = $map[x][y]

  return [[x, y]] if current == 9

  result = []

  neighbors(x, y).map do |nx, ny|
    n = $map[nx][ny]

    next unless n == current + 1
    next if visited.include?([nx, ny])

    result = [*result, *dfs(nx, ny, [*visited, [x, y]])]
  end

  result.uniq
end

def dfs2(x, y, visited = [])
  current = $map[x][y]

  return 1 if current == 9

  neighbors(x, y).sum do |nx, ny|
    n = $map[nx][ny]

    next 0 unless n == current + 1
    next 0 if visited.include?([nx, ny])

    dfs2(nx, ny, [*visited, [x, y]])
  end
end

sum = 0
sum2 = 0

$map.each_with_index do |row, i|
  row.each_with_index do |cell, j|
    next unless cell.zero?

    sum += dfs(i, j).size
    sum2 += dfs2(i, j)
  end
end

puts sum
puts sum2

# rubocop:enable Naming/MethodParameterName
# rubocop:enable Style/GlobalVars

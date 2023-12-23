# INPUT = 'input-sample.txt'
INPUT = 'input.txt'

$grid = File.read(INPUT).split("\n").map(&:chars)

start = [0, 1]
target = [$grid.size - 1, $grid.last.index('.')]

def junction?(x, y)
  neighbours = [
    [x - 1, y],
    [x + 1, y],
    [x, y - 1],
    [x, y + 1],
  ]

  neighbours.count { |i, j| i >= 0 &&j >= 0 && i < $grid.size && j < $grid.last.size && $grid[i][j] != '#' } !=  2
end

junctions = []
$distances = {}

$grid.each_with_index do |row, i|
  row.each_with_index do |cell, j|
    junctions << [i, j] if cell == '.' && junction?(i, j)
  end
end

junctions.each do |junction|
  distance = 0
  visited = Set.new
  to_visit = [[junction, 0]]

  until to_visit.empty?
    current, distance = to_visit.shift
    x, y = current

    if current != junction && junctions.include?(current)
      $distances[[junction, current]] = distance
      next
    end

    visited << current

    neighbours = [
      [x - 1, y],
      [x + 1, y],
      [x, y - 1],
      [x, y + 1],
    ]

    next_to_visit = neighbours.select do |i, j|
      i >= 0 &&j >= 0 && i < $grid.size && j < $grid.first.size &&
        ($grid[i][j] != '#') && !visited.include?([i, j])
    end

    next_to_visit.each do |i, j|
      to_visit << [[i, j], distance + 1]
    end
  end
end

def neighbours_of(junction) = $distances.keys.select { |k| k.first == junction }.map(&:last)

$neighbours = {}
junctions.each { $neighbours[_1] = neighbours_of(_1) }

$current_path = Set.new [start]

def longest_path(start, target)
  return 0 if start == target

  $neighbours[start].select { !$current_path.include?(_1) }.map do |neighbour|
    $current_path << neighbour
    result = $distances[[start, neighbour]] + longest_path(neighbour, target)
    $current_path.delete neighbour

    result
  end.max || 0
end

p longest_path(start, target)
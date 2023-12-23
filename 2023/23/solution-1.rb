# INPUT = 'input-sample.txt'
INPUT = 'input.txt'

$grid = File.read(INPUT).split("\n").map(&:chars)
$distance = {}

start = [0, 1]
target = [$grid.size.pred, $grid.last.index('.')]

to_visit = [[start, 0]]

until to_visit.empty?
  current, distance = to_visit.shift
  x, y = current

  $distance[current] = [$distance[current], distance].compact.max

  neighbours = [
    [x - 1, y, '^'],
    [x + 1, y, 'v'],
    [x, y - 1, '<'],
    [x, y + 1, '>'],
  ]

  next_to_visit = neighbours.select do |i, j, arrow|
    i >= 0 &&j >= 0 && i < $grid.size && j < $grid.last.size &&
      ($grid[i][j] == '.' || $grid[i][j] == arrow) &&
      (!$distance[[i, j]] || $distance[[i, j]] != distance - 1)
  end

  next_to_visit.each { |i, j, _| to_visit << [[i, j], distance + 1] }
end

p $distance[target]
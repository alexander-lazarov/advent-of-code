input = File.read('input.txt').split("\n")
# input = File.read('input-sample.txt').split("\n")

def manhattan_distance(a, b) = (a[0] - b[0]).abs + (a[1] - b[1]).abs

max_y = input.size
max_x = input[0].size
from = nil

walls = Set.new
distances = Hash.new

input.each_with_index do |line, y|
  line.strip.chars.each_with_index do |char, x|
    case char
    when '#' then walls.add([x, y])
    when 'S' then from = [x, y]
    end
  end
end

queue = [[from, 0]]
visited = Set.new

until queue.empty?
  current, distance = queue.shift

  visited.add(current)
  distances[current] = distance

  [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |dx, dy|
    x, y = current[0] + dx, current[1] + dy

    next if x <= 0 || y <= 0 || x >= max_x - 1 || y >= max_y - 1

    new_pos = [x, y]
    next if visited.include?(new_pos)
    next if walls.include?(new_pos)

    queue.push([new_pos, distance + 1])
    queue = queue.uniq
  end
end

p (distances.keys.combination(2).count do |a, b|
  d = manhattan_distance(a, b)
  next false if d > 2

  (distances[a] - distances[b]).abs - d >= 100
end)

p (distances.keys.combination(2).count do |a, b|
  d = manhattan_distance(a, b)
  next false if d > 20

  (distances[a] - distances[b]).abs - d >= 100
end)


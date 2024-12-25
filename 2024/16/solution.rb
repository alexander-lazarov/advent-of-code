input = File.read('input.txt').split("\n")
# input = File.read('input-sample.txt').split("\n")
# input = File.read('input-sample2.txt').split("\n")

walls = Set.new
from, to = nil, nil

max_x = input[0].length
max_y = input.length

input.each_with_index do |line, y|
  line.split('').each_with_index do |char, x|
    case char
    when '#' then walls.add([x, y])
    when 'S' then from = [x, y]
    when 'E' then to = [x, y]
    end
  end
end

dirs = [[-1, 0], [0, 1], [1, 0], [0, -1]]
initial_dir = 2
queue = [[from, initial_dir, 0, nil]]

visited = Set.new

min_path = {}
$origins = {}

while !queue.empty?
  queue = queue.uniq.sort_by { -_1[2] }

  pos, dir, cost, origin = queue.pop

  visited.add([pos, dir])

  $origins[pos] ||= Set.new
  $origins[pos].add(origin)

  min_path[pos] = cost

  to_check = [
    [[pos[0] + dirs[dir][0], pos[1] + dirs[dir][1]], dir, cost + 1, pos],
    [pos, (dir + 1) % 4, cost + 1000, origin],
    [pos, (dir - 1) % 4, cost + 1000, origin],
  ]

  to_check.each do |new_pos, new_dir, new_cost, new_origin|
    next if new_pos[0] < 0 || new_pos[0] >= max_x || new_pos[1] < 0 || new_pos[1] >= max_y
    next if walls.include?(new_pos)
    next if visited.include?([new_pos, new_dir])
    next if visited.include?([new_pos, (new_dir + 2) % 4])

    queue.push([new_pos, new_dir, new_cost, new_origin])
  end
end

puts min_path[to]

$tiles = Set.new

def dfs(pos)
  $tiles.add(pos)

  ($origins[pos] || []).each { dfs(_1) }
end

dfs(to)

$tiles.delete(nil)
puts $tiles.size


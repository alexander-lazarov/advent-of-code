input, steps, target  = File.read('input.txt').split("\n"), 1024, [70, 70]
# input, steps, target = File.read('input-sample.txt').split("\n"), 12, [6, 6]

coords = Set.new(input.map {_1.split(',').map(&:to_i)}[0...steps])

def bfs(start, target, coords)
  visited = Set.new
  queue = [[start, 0]]

  until queue.empty?
    current, steps = queue.shift

    return steps if current == target

    visited.add(current)

    [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |dx, dy|
      x, y = current[0] + dx, current[1] + dy
      new_pos = [x, y]

      next if x < 0 || y < 0 || x > target[0] || y > target[1]
      next if coords.include?(new_pos)
      next if visited.include?(new_pos)

      queue.push([new_pos, steps + 1])
      queue = queue.uniq
    end
  end
end

puts bfs([0, 0], target, coords)

((2.5*steps).to_i...input.size).each do |i|
  arr = input.map {_1.split(',').map(&:to_i)}[0...i]
  coords = Set.new(arr)

  unless bfs([0, 0], target, coords)
    puts arr.last.join(',')
    break
  end
end


# input = File.read('input-sample.txt')
input = File.read('input.txt')

grid, instructions = input.split("\n\n")

tiles = Hash.new
current = nil

grid.split("\n").each_with_index do |line, i|
  line.strip.split('').each_with_index do |char, j|
    case char
    when '#'
      tiles[[i, 2 * j]] = '#'
      tiles[[i, 2 * j + 1]] = '#'
    when 'O'
      tiles[[i, 2 * j]] = '['
      tiles[[i, 2 * j + 1]] = ']'
    when '@' then current = [i, 2 * j]
    end
  end
end

dirs = { '^' => [-1, 0], 'v' => [1, 0], '<' => [0, -1], '>' => [0, 1] }

instructions.strip.split('').each do |c|
  dir = dirs[c]

  next unless dir

  to_move = Set.new
  will_move = true
  visited = Set.new

  queue = [[current[0] + dir[0], current[1] + dir[1]]]

  while queue.size > 0
    queue = queue.uniq
    to_visit = queue.shift
    visited << to_visit

    case tiles[to_visit]
    when '#'
      will_move = false
      break
    when '['
      to_move << [to_visit, '[']
      unless visited.include?([to_visit[0] + dir[0], to_visit[1] + dir[1]])
        queue << [to_visit[0] + dir[0], to_visit[1] + dir[1]]
      end
      queue << [to_visit[0], to_visit[1] + 1] unless visited.include?([to_visit[0], to_visit[1] + 1])
    when ']'
      to_move << [to_visit, ']']
      unless visited.include?([to_visit[0] + dir[0], to_visit[1] + dir[1]])
        queue << [to_visit[0] + dir[0], to_visit[1] + dir[1]]
      end
      queue << [to_visit[0], to_visit[1] - 1] unless visited.include?([to_visit[0], to_visit[1] - 1])
    end
  end

  next unless will_move

  to_move.each { tiles.delete(_1[0]) }
  to_move.each { tiles[[_1[0] + dir[0], _1[1] + dir[1]]] = _2 }

  current = [current[0] + dir[0], current[1] + dir[1]]
end

p tiles.filter { _2 == '[' }.keys.sum { _1[0] * 100 + _1[1] }


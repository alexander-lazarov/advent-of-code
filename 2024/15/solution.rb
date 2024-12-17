# input = File.read('input-sample.txt')
input = File.read('input.txt')

grid, instructions = input.split("\n\n")

tiles = Hash.new
current = nil

grid.split("\n").each_with_index do |line, i|
  line.strip.split('').each_with_index do |char, j|
    case char
    in '#' | 'O' then tiles[[i, j]] = char
    in '@' then current = [i, j]
    in '.' then next
    end
  end
end

dirs = { '^' => [-1, 0], 'v' => [1, 0], '<' => [0, -1], '>' => [0, 1] }

instructions.strip.split('').each do |c|
  dir = dirs[c]

  next unless dir

  to_move = Set.new
  will_move = nil

  i = 0
  loop do
    i += 1
    new_pos = [current[0] + dir[0] * i, current[1] + dir[1] * i]

    if tiles[new_pos] == '#'
      will_move = false
      break
    elsif tiles[new_pos] == 'O'
      to_move << new_pos
    elsif !tiles.key?(new_pos)
      will_move = true
      break
    end
  end

  next unless will_move

  to_move.each { tiles.delete(_1) }
  to_move.each { tiles[[_1[0] + dir[0], _1[1] + dir[1]]] = 'O' }

  current = [current[0] + dir[0], current[1] + dir[1]]
end

p tiles.filter { _2 == 'O' }.keys.sum { _1[0] * 100 + _1[1] }


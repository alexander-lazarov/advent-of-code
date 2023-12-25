input = File.read('input.txt').chomp.split('')

def movement(char)
  case char
  in '>' then [1, 0]
  in '<' then [-1, 0]
  in '^' then [0, 1]
  in 'v' then [0, -1]
  end
end

def movements(input)
  s = Set.new
  s << [0, 0]
  x, y = 0, 0
  input.each do
    dx, dy = movement _1
    x += dx
    y += dy
    s << [x, y]
  end
  s
end

puts movements(input).size

santa_input = input.each_slice(2).map(&:first)
robo_santa_input = input.each_slice(2).map(&:last)

puts movements(santa_input).union(movements(robo_santa_input)).size

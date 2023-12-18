# INPUT = 'input-sample.txt'
INPUT = 'input.txt'

input = File.read(INPUT).scan(/(R|L|U|D)\ (\d+) \(#([0-9a-f]{6})\)/).map { |dir, l, c| [dir, l.to_i, c] }

def read_input_1(input) = input.map { |dir, length| [dir, length ]}
def read_input_2(input)
  input.map do |(_, _, c)|
    length = c[0..4].to_i(16)
    dir = case c[5]
          in '0' then 'R'
          in '1' then 'D'
          in '2' then 'L'
          in '3' then 'U'
          end

    [dir, length]
  end
end

def solve(input)
  dirs = {'R' => [1, 0], 'L' => [-1, 0], 'U' => [0, 1], 'D' => [0, -1]}

  input.inject([[0, 0]]) do |corners, (dir, length)|
    corners << [corners.last[0] + dirs[dir][0] * length, corners.last[1] + dirs[dir][1] * length]
  end.each_cons(2).map { |a, b| a[0] * b[1] - a[1] * b[0] }.sum.abs / 2 + input.sum { _2 } / 2 + 1
end

p solve(read_input_1(input))
p solve(read_input_2(input))

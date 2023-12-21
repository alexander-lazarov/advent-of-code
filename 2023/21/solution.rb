# INPUT = 'input-sample.txt'
INPUT = 'input.txt'

boards_to_expand = 9
$board = File.read(INPUT).split("\n").map { _1 * boards_to_expand }
$board = $board * boards_to_expand
$board.map! { _1.gsub('S', '.').split('') }

$w = $board.size
$h = $board[0].size

start = [$w/2, $h/2]
$board[start[0]][start[1]] = 0

current = [start]

def neighbours(x, y) = [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]]

(65 * boards_to_expand).times do |i|
  next_current = []

  current.each {|(x, y)| $board[x][y] = i }

  current.each do |(x, y)|
    next_current +=  neighbours(x, y).select do |(x, y)|
      x >= 0 && x < $w && y >= 0 && y < $h && $board[x][y] == '.'
    end
  end

  current = next_current.uniq
end

t = $board.flatten.tally

def solve(tally, i) = tally.keys.filter { _1.is_a?(Integer) && _1 % 2 == i % 2 && _1 <= i }.sum { tally[_1] }

# part 1
p solve(t, 64)

# part 2
pts = [0, 1, 2]
pts.each { |i| puts "#{i} * r -> #{solve(t, 131 * i + 65)}" }

# get the coefficients of the quadratic equation from WA
def f(x) = 3642 - 14737*x + 14871*x*x

p f(26501365 / 131 + 1)

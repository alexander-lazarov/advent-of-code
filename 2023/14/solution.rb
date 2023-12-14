# INPUT = 'input-sample.txt'
INPUT = 'input.txt'

grid = File.read(INPUT).split("\n").map { _1.chars }

def slide(row)
  result = row.join('').split('#').map { _1.chars }.map { _1.sort.reverse.join('') }.join('#')

  (result + '#' * (row.size - result.size)).chars
end

def weight(row) = row.reverse.zip(1..).sum { _1 == 'O' ? _2 : 0 }

# Part 1
p grid.transpose.map { slide(_1) }.sum { weight(_1) }

results = {}

cycle_length = nil
cycle_start = nil

TARGET = 1_000_000_000

TARGET.times do |i|
  grid = grid.transpose.map { slide(_1) }.transpose
  grid = grid.map { slide(_1) }
  grid = grid.transpose.map { slide(_1.reverse).reverse }.transpose
  grid = grid.map { slide(_1.reverse).reverse }

  key = grid.dup

  if results.key?(key)
    cycle_length = i - results[key]
    cycle_start = results[key] - 1
    break
  end

  results[key] = i
end

i = (TARGET - results.size) % cycle_length
# Part 2
p results.key(cycle_start + i).transpose.sum { weight(_1) }
# INPUT = 'input-sample.txt'
INPUT = 'input.txt'

patterns = File.read(INPUT).split("\n\n").map { _1.split("\n").map { |row| row.split('') } }

def diff(r, x)
  a, b = r[0...x].reverse, r[x..]
  m = [a.size, b.size].min

  a[0...m].zip(b[0...m]).count { _1 != _2 }
end

def col(p, d) = (1...(p.first.size)).to_a.find { |i| p.sum { diff(_1, i) } == d } || 0
def row(p, d) = col(p.transpose, d)

p patterns.sum { col(_1, 0) + row(_1, 0) * 100 }
p patterns.sum { col(_1, 1) + row(_1, 1) * 100 }
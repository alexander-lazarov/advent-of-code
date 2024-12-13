# frozen_string_literal: true

# input = File.read('input-sample.txt')
input = File.read('input.txt')

groups = input.split("\n\n")

groups.map! do |group|
  a, b, t = group.split("\n")

  {
    a: a.split(' ')[2..].map { _1[1..] }.map(&:to_i),
    b: b.split(' ')[2..].map { _1[1..] }.map(&:to_i),
    t: t.split(' ')[1..].map { _1[2..] }.map(&:to_i)
  }
end

groups_2 = groups.map do |group|
  {
    a: group[:a],
    b: group[:b],
    t: group[:t].map { _1 + 10000000000000 }
  }
end

def s(a, b, t)
  i = (t[0] * b[1] - t[1] * b[0]) / (b[1] * a[0] - b[0] * a[1])
  j = (t[0] * a[1] - t[1] * a[0]) / (a[1] * b[0] - b[1] * a[0])

  if a[0] * i + b[0] * j == t[0] && a[1] * i + b[1] * j == t[1]
    i * 3 + j
  else
    0
  end
end

p groups.sum { s(_1[:a], _1[:b], _1[:t]) }
p groups_2.sum { s(_1[:a], _1[:b], _1[:t]) }

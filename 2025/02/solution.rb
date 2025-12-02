# input = 'input-sample.txt'
input = 'input.txt'

ids = (File.readlines(input).join.strip.split(',').map do
  first, second = it.split('-').map(&:to_i)

  (first..second).to_a
end.flatten)

puts (ids.filter do |id|
  s = id.to_s

  s == s[0..s.length / 2 - 1] * 2
end.sum)

puts (ids.filter do |id|
  s = id.to_s
  l = s.length

  (1..(l / 2)).filter { l % it == 0 }.any? { s == s[0...it] * (l / it) }
end.sum)


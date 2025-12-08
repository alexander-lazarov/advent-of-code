input, rounds = 'input.txt', 1000
# input, rounds = 'input-sample.txt', 10
junctions = File.readlines(input).map{ it.split(',').map(&:to_i) }
circuits = junctions.map { [it] }

distances = junctions.combination(2).map do |j1, j2|
  [Math.sqrt(j1.zip(j2).map { (_1 - _2) ** 2 }.reduce(:+)), j1, j2]
end.sort_by { it[0] }

distances.take(rounds).map { [it[1], it[2]] }.each do |j1, j2|
  c1 = circuits.find { it.include?(j1) }
  c2 = circuits.find { it.include?(j2) }

  next if c1 == c2

  circuits.delete(c1)
  circuits.delete(c2)
  circuits.push(c1 + c2)
end

p circuits.map { it.size }.sort.reverse.take(3).reduce(:*)

distances.each do |d, j1, j2|
  c1 = circuits.find { it.include?(j1) }
  c2 = circuits.find { it.include?(j2) }

  next if c1 == c2

  circuits.delete(c1)
  circuits.delete(c2)
  circuits.push(c1 + c2)

  if circuits.size == 1
    p j1[0] * j2[0]
    break
  end
end


input, rounds = 'input.txt', 1000
# input, rounds = 'input-sample.txt', 10
junctions = File.readlines(input).map{ it.split(',').map(&:to_i) }
circuits = junctions.map { [it] }

junctions.
  combination(2).
  sort_by { |j1, j2| j1.zip(j2).map { (_1 - _2) ** 2 }.reduce(:+) }.
  each.with_index do |(j1, j2), i|
    c1 = circuits.find { it.include?(j1) }
    c2 = circuits.find { it.include?(j2) }

    if c1 != c2
      circuits -= [c1, c2]
      circuits.push(c1 + c2)
    end

    p circuits.map { it.size }.sort.last(3).reduce(:*) if i == rounds - 1
    (p j1[0] * j2[0]) && break if circuits.size == 1
  end


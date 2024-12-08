# frozen_string_literal: true

# input = File.read('input-sample.txt').lines
input = File.read('input.txt').lines.map(&:strip)

groups = Hash.new { |hash, key| hash[key] = [] }
max = input.size, input[0].size

input.each_with_index do |line, x|
  line.split('').each_with_index do |char, y|
    groups[char] << [x, y] unless char == '.'
  end
end

antinodes = Set.new, Set.new
resonances = [[1, -2], (-max[0] * 2).upto(max[0] * 2)]

groups.each_value do |group|
  group.combination(2).each do |a, b|
    diff = a[0] - b[0], a[1] - b[1]

    resonances.each_with_index do |resonance, r|
      resonance.each do |i|
        n = a[0] + diff[0] * i, a[1] + diff[1] * i

        antinodes[r].add(n) if n[0] >= 0 && n[1] >= 0 && n[0] < max[0] && n[1] < max[1]
      end
    end
  end
end

puts antinodes[0].size
puts antinodes[1].size

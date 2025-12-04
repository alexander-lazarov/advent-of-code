# frozen_string_literal: true

# input = 'input-sample.txt'
input = 'input.txt'

paper = Set.new

File.readlines(input).each_with_index do |line, y|
  line.split('').each_with_index { |char, x| paper << (x + y * 1i) if char == '@' }
end

def pickable?(paper, pos)
  paper.member?(pos) &&
    ([1, -1, 1i, -1i, 1 + 1i, 1 - 1i, -1 + 1i, -1 - 1i].count { paper.member?(pos + it) } < 4)
end

puts(paper.count { pickable?(paper, it) })

initial_count = paper.size
loop do
  to_remove = paper.select { pickable?(paper, it) }
  paper -= to_remove
  break if to_remove.empty?
end

puts(initial_count - paper.size)

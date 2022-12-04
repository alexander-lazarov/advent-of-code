filename = 'input.txt'
# filename = 'input-sample.txt'

pairs = File.read(filename).split("\n").map { |l| l.split(",").map { |pair| Range.new(*pair.split('-').map(&:to_i)) } }

puts pairs.count { |a, b| a.cover?(b) || b.cover?(a) }
puts pairs.count { |a, b|!(a.to_a & b.to_a).empty? }
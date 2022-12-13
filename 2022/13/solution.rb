input = File.read('input.txt')
# input = File.read('input-sample.txt')

pairs = input.split("\n\n").map { |p| p.split("\n").map { |a| eval(a) } }

def cmp(a, b)
  if a.is_a?(Integer) && b.is_a?(Integer)
    a <=> b
  elsif a.is_a?(Integer)
    cmp([a], b)
  elsif b.is_a?(Integer)
    cmp(a, [b])
  elsif a.is_a?(Array) && b.is_a?(Array)
    a.zip(b).each do |l, r|
      return -1 if l.nil?
      return 1 if r.nil?

      res = cmp(l, r)

      return res unless res.zero?
    end

    a.size <=> b.size
  else
    raise ArgumentError, "Cannot handle #{a} and #{b}"
  end
end

puts "Part 1:"
puts pairs.zip(1..).filter { |pair, num| cmp(*pair) < 0 }.sum { |_, i| i }

packets = [[[2]], [[6]]]
pairs_2 = (pairs.flatten(1) + packets).sort { |a, b| cmp(a, b) }

puts ""
puts "Part 1:"
puts packets.map { |p| pairs_2.find_index(p) + 1 }.reduce(&:*)


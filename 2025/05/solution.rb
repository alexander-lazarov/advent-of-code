input = "input.txt"
# input = "input-sample.txt"

ranges, ids = File.read(input).split("\n\n").map { it.split("\n") }

ranges.map! do |range|
  min, max = range.match(/(\d+)-(\d+)/).captures.map(&:to_i)
  min..max
end

ids.map!(&:to_i)

puts ids.count { |id| ranges.any? { it.include?(id) } }

loop do
  merged = false

  ranges.combination(2) do |a, b|
    next unless a.overlap?(b)

    ranges.delete(a)
    ranges.delete(b)
    ranges.push([a.first, b.first].min..[a.last, b.last].max)
    merged = true

    break
  end

  break unless merged
end

puts ranges.sum(&:size)

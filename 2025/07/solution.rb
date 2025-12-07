input = 'input.txt'
# input = 'input-sample.txt'
lines = File.readlines(input)
splits = 0
counts = {lines.first.index('S') => 1}

lines.each do |line|
  next_counts = Hash.new(0)

  counts.each do |pos, c|
    if line[pos] == '^'
      splits += 1
      next_counts[pos - 1] += c
      next_counts[pos + 1] += c
    else
      next_counts[pos] += c
    end
  end

  counts = next_counts
end

puts splits
puts counts.values.sum


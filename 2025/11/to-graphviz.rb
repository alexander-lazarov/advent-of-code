input = 'input.txt'

neighbours = File.readlines(input).map do |line|
  from, rest = line.strip.split(': ')

  [from, rest.split(' ')]
end.to_h

neighbours.each do |from, tos|
  puts "#{from} -> { #{tos.join(', ')} }"
end


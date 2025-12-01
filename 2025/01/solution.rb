input = 'input-sample.txt'
input = 'input.txt'

moves = File.readlines(input).map { it.sub('R', '-').sub('L', '+').to_i }

count, count2 = 0, 0
current = 50

moves.each do |move|
  old, current = current, current + move

  count += 1 if current % 100 == 0

  min, max = [old, current].sort
  count2 += (min + 1).upto(max - 1).count { it % 100 == 0 }
end

puts count
puts count + count2


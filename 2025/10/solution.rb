input = 'input.txt'
# input = 'input-sample.txt'

lines = File.readlines(input).map do |line|
  target, *buttons, joltage = line.split(' ')

  target = target[1..-2].chars.map.with_index { [_2, _1 == '#'] }.filter { _2 }.map { _1[0] }.to_set
  buttons.map! { |button| button[1..-2].split(',').map(&:to_i) }

  [target, buttons, joltage]
end

p (lines.sum do |target, buttons, _joltage|
  result = 0

  1.upto(buttons.size).count do |n|
    break if result > 0
    buttons.combination(n).each do |combination|
      if target == combination.flatten.tally.filter { _2  % 2 == 1}.keys.to_set
        result = n
        break
      end
    end
  end

  raise 'No solution found' if result == 0

  result
end)

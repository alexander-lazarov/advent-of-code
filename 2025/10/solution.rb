input = 'input.txt'
# input = 'input-sample.txt'

lines = File.readlines(input).map do |line|
  target, *buttons, joltage = line.split(' ')

  target = target[1..-2].chars.map.with_index { [_2, _1 == '#'] }.filter { _2 }.map { _1[0] }.to_set
  buttons.map! { it[1..-2].split(',').map(&:to_i) }
  joltage = joltage[1..-2].split(',').map(&:to_i)

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

  result
end)

require 'z3'

p (lines.sum do |target, buttons, joltage|
  optimizer = Z3::Optimize.new
  button_pushes = buttons.map.with_index { |_b, i| Z3.Int "x#{i}" }
  button_pushes.each { optimizer.assert(it >= 0) }

  joltage.each.with_index do |target_joltage, i|
    bs = buttons.map.with_index { |button, index| button.include?(i) ? button_pushes[index] : nil }.compact

    optimizer.assert(
      target_joltage == Z3.Add(*bs)
    )
  end

  optimizer.minimize(Z3.Add(*button_pushes))
  optimizer.satisfiable?

  optimizer.model.to_h { |zvar, zvalue| [zvar, zvalue.to_i] }.values.sum
end)


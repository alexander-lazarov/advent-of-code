# frozen_string_literal: true

# rubocop:disable Style/GlobalVars

# input = File.read('input-sample.txt').lines
input = File.read('input.txt').lines
numbers = input.first.split(' ').map(&:to_i)

$m = {}

def calc(number, times)
  return $m[[number, times]] if $m.key?([number, times])
  return 1 if times.zero?

  if number.zero?
    $m[[number, times]] = calc(1, times - 1)
  elsif number.to_s.size.even?
    n1 = number.to_s[0...(number.to_s.size / 2)].to_i
    n2 = number.to_s[(number.to_s.size / 2)..].to_i
    $m[[number, times]] = calc(n1, times - 1) + calc(n2, times - 1)
  else
    $m[[number, times]] = calc(number * 2024, times - 1)
  end
end

puts numbers.sum { calc(_1, 25) }
puts numbers.sum { calc(_1, 75) }

# rubocop:enable Style/GlobalVars

# frozen_string_literal: true

lines = File.readlines('input.txt')
# lines = File.readlines('input-sample.txt')
# lines = File.readlines('input-sample2.txt')

numbers = lines.map(&:to_i)

def advance_number(n)
  n = mix(n, n * 64)
  n = mix(n, n / 32)

  mix(n, n * 2048)
end

def mix(x, y) = x ^ y % 16_777_216

prices = []

$diff_map = {}

puts (numbers.sum do |n|
  current_prices = [n % 10]

  2000.times do
    current_prices << n % 10

    n = advance_number(n)
  end

  prices << current_prices

  n
end)

def diff_patterns(price_sequence) = price_sequence.each_cons(2).map { _2 - _1 }.each_cons(4).uniq

all_patterns = prices.map { diff_patterns(_1) }.flatten(1).uniq

prices.each_with_index do |price_sequence, i|
  cons = price_sequence.each_cons(2).map { |a, b| b - a }.each_cons(4).to_a

  hash = {}

  cons.each_with_index do |pattern, j|
    hash[pattern] = price_sequence[j + 4]
  end

  $diff_map[price_sequence] = hash
end

max = 0

all_patterns.each do |pattern|
  s = prices.sum { $diff_map[_1][pattern] || 0 }
  max = s if s > max
end

puts max

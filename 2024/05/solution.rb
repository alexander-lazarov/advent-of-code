# frozen_string_literal: true

# rubocop:disable Style/GlobalVars
# input = File.read('input-sample.txt')
input = File.read('input.txt')

$rules, orders = input.split("\n\n")
$rules = Set.new($rules.split("\n").map { _1.split('|').map(&:to_i) })
orders = orders.split("\n").map { _1.split(',').map(&:to_i) }

def correct_order?(order)
  return true if order.size == 1

  order[1..].all? { $rules.include? [order[0], _1] } && correct_order?(order[1..])
end

def middle_of(arr) = arr[arr.size / 2]

def make_correct(order)
  return order if order.size == 1

  order.each do |head|
    rest = order.reject { _1 == head }
    next unless rest.all? { $rules.include? [_1, head] }

    correct_tail = make_correct(rest)
    return [head, *correct_tail] if correct_tail
  end

  false
end

puts (orders.select { correct_order?(_1) }).sum { middle_of(_1) }
puts (orders.reject { correct_order?(_1) }).sum { middle_of(make_correct(_1)) }

# rubocop:enable Style/GlobalVars

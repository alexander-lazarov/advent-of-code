input = File.read('input.txt')
# input = File.read('input-sample.txt')

a, b = input.split("\n\n")

$initial_values = Hash[
  a.split("\n").map do |line|
    key, val = line.split(': ')
    [key, val == '1']
  end
]

$wiring = Hash[
  b.split("\n").map do |line|
    f, key = line.split(' -> ')
    a, op, b = f.split(' ')

    [key, [a, op, b]]
  end
]

def ev(key)
  return $initial_values[key] if $initial_values.key?(key)

  a, op, b = $wiring[key]

  a_val = ev(a)
  b_val = ev(b)

  $initial_values[key] =
    case op
    in 'AND' then a_val && b_val
    in 'OR' then a_val || b_val
    in 'XOR' then a_val ^ b_val
    end
end

$wiring.keys.filter { _1.start_with?('z') }.each do |key|
  ev(key)
end

pp $initial_values

p ($initial_values.filter { _1[0].start_with?('z') }.map do |key, val|
  [key, val ? 1 : 0]
end.sort_by { _1[0] }.reverse.map(&:last).join.to_i(2))

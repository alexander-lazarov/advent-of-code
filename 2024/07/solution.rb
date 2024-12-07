# frozen_string_literal: true

# input = File.read('input-sample.txt').lines
input = File.read('input.txt').lines

input = input.map do |i|
  s = i.split(':')

  { target: s[0].to_i, parts: s[1].split(' ').map(&:to_i) }
end

def possible?(target, parts)
  return parts[0] * parts[1] == target || parts[0] + parts[1] == target if parts.size == 2

  possible?(target, [parts[0] + parts[1], *parts[2..]]) ||
    possible?(target, [parts[0] * parts[1], *parts[2..]])
end

def concat(a, b)
  "#{a}#{b}".to_i
end

def possible_2?(target, parts)
  if parts.size == 2
    return parts[0] * parts[1] == target || parts[0] + parts[1] == target || concat(parts[0], parts[1]) == target
  end

  possible_2?(target, [parts[0] + parts[1], *parts[2..]]) ||
    possible_2?(target, [parts[0] * parts[1], *parts[2..]]) ||
    possible_2?(target, [concat(parts[0], parts[1]), *parts[2..]])
end

p input.select { possible?(_1[:target], _1[:parts]) }.sum { _1[:target] }
p input.select { possible_2?(_1[:target], _1[:parts]) }.sum { _1[:target] }

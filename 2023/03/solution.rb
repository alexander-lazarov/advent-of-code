# frozen_string_literal: true

# INPUT = 'input-sample.txt'
INPUT = 'input.txt'

lines = File.read(INPUT).split("\n").map { "#{_1}." }.map(&:chars)

nums = []

lines.each_with_index do |line, i|
  num_start = nil
  num = ''

  line.each_with_index do |char, j|
    if !char.match(/\d/) && num_start
      nums << { row: i, col_start: num_start, col_end: j - 1, num: num.to_i }
      num_start = nil
      num = ''
    elsif char.match?(/\d/)
      num_start = j if num_start.nil?
      num += char
    end
  end
end

def char_at(lines, i, j)
  return '.' if i.negative? || j.negative?

  lines.fetch(i, []).fetch(j, '.')
end

def border_of(num)
  result = []

  result.push([num[:row], num[:col_start] - 1])
  result.push([num[:row], num[:col_end] + 1])

  ((num[:col_start] - 1)..(num[:col_end] + 1)).each do |j|
    result.push([num[:row] - 1, j])
    result.push([num[:row] + 1, j])
  end

  result
end

def wanted?(num, lines) = !border_of(num).all? { |x, y| char_at(lines, x, y) == '.' }

# part 1
puts nums.filter { |num| wanted?(num, lines) }.map { _1[:num] }.sum

def adjacent_to(num, lines, x, y) = border_of(num).include?([x, y])
def adjacent_nums(nums, lines, i, j) = nums.filter { adjacent_to(_1, lines, i, j) }

result = 0

lines.each_with_index do |line, i|
  line.each_with_index do |char, j|
    if char == '*'
      adj = adjacent_nums(nums, lines, i, j)
      result += adj[0][:num] * adj[1][:num] if adj.length == 2
    end
  end
end

# part 2
puts result

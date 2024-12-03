# frozen_string_literal: true

input = File.read('input-sample.txt')
# input = File.read('input.txt')

puts input.scan(/mul\((\d+),(\d+)\)/).sum { _1.to_i * _2.to_i }

sum = 0
enabled = true

input.scan(/(mul\(\d+,\d+\))|(do\(\))|(don't\(\))/).each do |mul, doo, dont|
  if mul && enabled
    sum +=  mul.scan(/\d+/).map(&:to_i).reduce(:*)
  elsif doo
    enabled = true
  elsif dont
    enabled = false
  end
end

puts sum

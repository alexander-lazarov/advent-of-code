# input = 'input-sample.txt'
input = 'input.txt'

lines = File.readlines(input).map { it.split('').map(&:to_i) }

def maximum(nums, l)
  max = nums[0...(nums.length - l)].max

  if l == 1
    max
  else
    "#{max}#{maximum(nums[nums.index(max) + 1..], l - 1)}".to_i
  end
end

puts lines.sum { maximum(it, 2) }
puts lines.sum { maximum(it, 12) }


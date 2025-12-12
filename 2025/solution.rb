input = 'input.txt'
# input = 'input-sample.txt'

p (File.readlines(input).count do |line|
  a, b = line.split(': ')

  mul = a.split('x').map(&:to_i).reduce(:*)
  nums = b.scan(/\d+/).map(&:to_i)

  mul > nums.sum * 8
end)

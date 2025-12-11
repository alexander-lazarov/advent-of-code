input = 'input.txt'
# input = 'input-sample.txt'
# input = 'input-sample-2.txt'

$neighbours = File.readlines(input).map do |line|
  from, rest = line.strip.split(': ')
  [from, rest.split(' ')]
end.to_h

$memo = {}

def count(node, target)
  return $memo[[node, target]] if $memo.key?([node, target])
  result = node == target ? 1 : ($neighbours[node] || []).sum { count(it, target) }
  $memo[[node, target]] = result
end

p count('you', 'out')
p(
  count('svr', 'dac') * count('dac', 'fft') * count('fft', 'out') +
  count('svr', 'fft') * count('fft', 'dac') * count('dac', 'out')
)

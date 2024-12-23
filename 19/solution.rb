input = File.read('input.txt')
# input = File.read('input-sample.txt')

a, b = input.split("\n\n")

$towels = a.strip.split(', ')
targets = b.split("\n").map(&:strip)

$memo = {}

def solve(target)
  return 1 if target.empty?

  return $memo[target] if $memo.key?(target)

  $memo[target] = ($towels.sum do |towel|
    if target.start_with?(towel)
      solve(target[towel.length..])
    else
      0
    end
  end)

  $memo[target]
end

puts targets.count { solve(_1) > 0 }
puts targets.sum { solve(_1) }


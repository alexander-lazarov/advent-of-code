words = File.read('input.txt').split("\n")

# part 1
puts (words.count do
  _1.scan(/[aeiou]/).count >= 3 &&
    _1.scan(/(\w)\1/).count >= 1 &&
    _1 !~ /ab|cd|pq|xy/
end)

# part 2
puts (words.count { _1.scan(/(..).*\1/).count >= 1 && _1.scan(/(.).\1/).count >= 1 })

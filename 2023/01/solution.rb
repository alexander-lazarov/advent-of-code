# input = File.read('input-sample.txt').split("\n")
input = File.read('input.txt').split("\n")

def digit?(str)
  code = str.ord
  code >= 48 && code <= 57
end

# rubocop:disable Style/MultilineBlockChain

replace = {
  'one' => '1',
  'two' => '2',
  'three' => '3',
  'four' => '4',
  'five' => '5',
  'six' => '6',
  'seven' => '7',
  'eight' => '8',
  'nine' => '9'
}

pp input.map { |line| line.split('').filter { |c| digit?(c) } }.map { |l| "#{l.first}#{l.last}".to_i }.sum

puts(input.map do |line|
  line = line.sub(/(one|two|three|four|five|six|seven|eight|nine)/) { |match| replace[match] }
  line = line.reverse
  line = line.sub(/(enin|thgie|neves|xis|evif|ruof|eerht|owt|eno)/) { |match| replace[match.reverse] }
  line = line.reverse

  line
end.map do |line|
  line.split('').filter do |c|
    digit?(c)
  end
end.map { |l| "#{l.first}#{l.last}".to_i }.sum)

# rubocop:enable Style/MultilineBlockChain

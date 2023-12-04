# lines = File.read('input-sample.txt').split("\n")
lines = File.read('input.txt').split("\n")

cards = []

lines.map do |line|
  id_with_card, nums = line.split(':')

  id = id_with_card.split(' ')[1].to_i

  winning, yours = nums.split('|')

  winning = winning.split(' ').map(&:to_i)
  yours = yours.split(' ').map(&:to_i)

  cards << { id: id, winning: winning, yours: yours }
end


scores = cards.map do |card|
  count = card[:winning].intersection(card[:yours]).count

  next count.zero? ? 0 : 2 ** (count - 1)
end

# part 1
pp scores.sum

card_nums = Array.new(cards.size, 1)

cards.each do |card|
  count = card[:winning].intersection(card[:yours]).count

  count.times { |i| card_nums[i + card[:id]] += card_nums[card[:id] - 1] }
end

pp card_nums.sum

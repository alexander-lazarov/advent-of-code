def paper(dimensions)
  sides = dimensions.combination(2).map { _1 * _2 }
  sides.sum * 2 + sides.min
end

def ribbon(dimensions) = dimensions.sort.take(2).sum * 2 + dimensions.reduce(:*)

boxes = File.read('input.txt').split("\n").map { |line| line.split('x').map(&:to_i) }

p boxes.sum { paper(_1) }
p boxes.sum { ribbon(_1) }


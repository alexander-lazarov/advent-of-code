# INPUT = 'input-sample.txt'
INPUT = 'input.txt'
KINDS = 'AKQJT98765432'
KINDS_JOKER = 'AKQT98765432J'

def hand_value(hand) = hand_type_rank(hand) * (100 ** 5) + (0..4).sum { KINDS.index(hand[_1]) * (100 ** (4 - _1)) }
def hand_value_joker(hand) = hand_type_joker_rank(hand) * (100 ** 5) + (0..4).sum { KINDS_JOKER.index(hand[_1]) * (100 ** (4 - _1)) }

def hand_type_rank(hand)
  case hand.tally.values.sort.reverse
  in [5] then return 0
  in [4, 1] then return 1
  in [3, 2] then return 2
  in [3, 1, 1] then return 3
  in [2, 2, 1] then return 4
  in [2, 1, 1, 1] then return 5
  in [1, 1, 1, 1, 1] then return 6
  end
end

def hand_type_joker_rank(card) = KINDS_JOKER.split('').map { hand_type_rank(card.join.gsub('J', _1).split('')) }.min

all = File.
  read(INPUT).
  split("\n").
  map { _1.split(' ') }.
  map { [_1.split(''), _2.to_i] }.
  map { [_2, hand_value(_1), hand_value_joker(_1)] }

p all.sort_by { -_2 }.zip(1..).sum { |(bid, _), i| i * bid }
p all.sort_by { -_3 }.zip(1..).sum { |(bid, _), i| i * bid }
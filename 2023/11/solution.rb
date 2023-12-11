# INPUT = 'input-sample.txt'
INPUT = 'input.txt'

board = File.read(INPUT).split("\n").map(&:chars)
rows_to_expand = []
board.each_with_index { rows_to_expand << _2 if _1.all? { |c| c == '.' } }
cols_to_expand = []
board.transpose.each_with_index { cols_to_expand << _2 if _1.all? { |c| c == '.' } }

galaxies = []
board.each_with_index do |row, i|
  row.each_with_index do |cell, j|
    galaxies << [i, j] if board[i][j] == '#'
  end
end

sum = 0
expanded_count = 0
s = galaxies.size

(0...s).each do |i|
  (i + 1...s).each do |j|
    expanded_count += rows_to_expand.count { _1 < galaxies[i][0] && _1 > galaxies[j][0] ||  _1 < galaxies[j][0] && _1 > galaxies[i][0] }
    expanded_count += cols_to_expand.count { _1 < galaxies[i][1] && _1 > galaxies[j][1] ||  _1 < galaxies[j][1] && _1 > galaxies[i][1] }
    sum += (galaxies[i][0] - galaxies[j][0]).abs + (galaxies[i][1] - galaxies[j][1]).abs
  end
end

p sum + expanded_count
p sum + expanded_count * 999999
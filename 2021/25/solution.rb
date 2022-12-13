# frozen_string_literal: true

require 'matrix'

filename = 'input.txt'
# filename = 'input-sample.txt'

input = File.read(filename)
step = 0

m = Matrix[*input.split("\n").map(&:chars)]
cols = m.column_count
rows = m.row_count

loop do
  moved = false

  rows.times do |i|
    row = m.row(i)

    to_move = (0...cols).to_a.reverse.filter do |j|
      row[j] == '>' && row[(j + 1) % cols] == '.'
    end

    to_move.each do |j|
      m[i, j] = '.'
      m[i, (j + 1) % cols] = '>'
    end

    moved = true unless to_move.empty?
  end

  cols.times do |j|
    col = m.column(j)

    to_move = (0...rows).to_a.reverse.filter do |i|
      col[i] == 'v' && col[(i + 1) % rows] == '.'
    end

    to_move.each do |i|
      m[i, j] = '.'
      m[(i + 1) % rows, j] = 'v'
    end

    moved = true unless to_move.empty?
  end

  step += 1

  break unless moved
end

puts step

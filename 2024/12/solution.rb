# frozen_string_literal: true

# input = File.read('input-sample.txt').lines
# input = File.read('input-sample2.txt').lines
input = File.read('input.txt').lines

letters = {}

input.map { |line| line.strip.chars }.each_with_index do |row, i|
  row.each_with_index do |cell, j|
    letters[cell] ||= Set.new
    letters[cell] << [i, j]
  end
end

def sides(letters)
  vertical_sides(letters) + horizontal_sides(letters)
end

def vertical_sides(letters)
  left_sides(letters) + right_sides(letters)
end

def horizontal_sides(letters)
  vertical_sides(letters.map(&:reverse))
end

def right_sides(letters)
  left_sides(letters.map { |i, j| [i, -j] })
end

def left_sides(letters)
  result = 0

  l = Set.new(letters.reject { |i, j| letters.include?([i, j - 1]) })

  until l.empty?
    queue = [l.first]
    l.delete(l.first)

    visited = Set.new

    until queue.empty?
      current = queue.first
      queue.delete(current)
      visited << current
      x, y = current
      [
        [x - 1, y], [x + 1, y]
      ].select { l.include?(_1) }.reject { visited.include?(_1) }.each do |neighbor|
        queue << neighbor
        l.delete(neighbor)
      end
    end

    result += 1
  end

  result
end

def partition(letters)
  result = []

  l = letters.dup

  until l.empty?
    queue = [l.first]
    l.delete(l.first)

    visited = Set.new

    until queue.empty?
      current = queue.first
      queue.delete(current)
      visited << current

      x, y = current

      [
        [x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]
      ].select { l.include?(_1) }.reject { visited.include?(_1) }.each do |neighbor|
        queue << neighbor
        l.delete(neighbor)
      end
    end

    result << visited
  end

  result
end

def perimeter(letters)
  letters.sum do |i, j|
    [
      [i - 1, j], [i + 1, j], [i, j - 1], [i, j + 1]
    ].count { !letters.include?(_1) }
  end
end

regions = letters.values.flat_map { partition(_1) }

puts(regions.sum { _1.size * perimeter(_1) })
puts(regions.sum { _1.size * sides(_1) })


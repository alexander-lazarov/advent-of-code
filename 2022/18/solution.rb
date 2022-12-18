require 'set'

input_file = 'input.txt'
# input_file = 'input-sample.txt'

points = Set.new(File.read(input_file).split("\n").map { _1.split(',').map(&:to_i) })

def neighbours_of(x, y, z)
  [
    [x + 1, y, z],
    [x - 1, y, z],
    [x, y + 1, z],
    [x, y - 1, z],
    [x, y, z + 1],
    [x, y, z - 1],
  ]
end

class OutsideCalc
  def initialize(points)
    @points = points

    @x_range = Range.new(*@points.map { _1[0] }.minmax)
    @y_range = Range.new(*@points.map { _1[1] }.minmax)
    @z_range = Range.new(*@points.map { _1[2] }.minmax)

    @outside = Set.new
  end

  def outside = @points.sum { neighbours_of(*_1).count { |p| outside?(p) } }

  private

  def outside?(point)
    return false if @points.include?(point)

    adj_area = Set.new
    stack = [point]

    while curr_point = stack.pop
      next if adj_area.include?(curr_point)

      adj_area.add(curr_point) unless @points.include?(curr_point)

      if @outside.include?(curr_point) || out?(*curr_point)
        @outside += adj_area

        return true
      end

      stack += neighbours_of(*curr_point) unless @points.include?(curr_point)
    end

    return false
  end

  def out?(x, y, z) = !@x_range.include?(x) || !@y_range.include?(y) || !@z_range.include?(z)
end

puts points.sum { |p| neighbours_of(*p).count { !points.include?(_1) } }

calc = OutsideCalc.new(points)
puts calc.outside
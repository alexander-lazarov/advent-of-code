instructions = File.read('input.txt').split("\n")
grid, grid_2 = Hash.new(false), Hash.new(0)

instructions.each do |instruction|
  x1, y1, x2, y2 = instruction.scan(/\d+/).map(&:to_i)
  x1, x2 = [x1, x2].sort
  y1, y2 = [y1, y2].sort

  command = case instruction
            in /turn on/ then :on
            in /turn off/ then :off
            in /toggle/ then :tgl
            end

  (x1..x2).each do |x|
    (y1..y2).each do |y|
      case command
      in :on
        grid[[x, y]] = true
        grid_2[[x, y]] += 1
      in :off
        grid[[x, y]] = false
        grid_2[[x, y]] -= 1 if grid_2[[x, y]] > 0
      in :tgl
        grid[[x, y]] = !grid[[x, y]]
        grid_2[[x, y]] += 2
      end
    end
  end
end

puts grid.values.count(true)
puts grid_2.values.sum

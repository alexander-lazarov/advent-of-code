INPUT = 'input-sample.txt'
INPUT = 'input.txt'

$grid = File.read(INPUT).split("\n").map { _1.chars }
$w = $grid[0].length
$h = $grid.length

energized = {
  [[0, 1], [0, 0]] => true
}

beams = [
  [[0, 1], [0, 0]]
]

def score(initial_beam)
  energized = {initial_beam => true}

  beams = [initial_beam]

  loop do
    break if beams.empty?
    next_beams = []

    beams.each_with_index do |beam, i|
      x_speed, y_speed = beam[0]
      x_pos, y_pos = beam[1]

      curr_next_beams =
        case $grid[x_pos][y_pos]
        in '.'
          [
            [[x_speed, y_speed], [x_pos + x_speed, y_pos + y_speed]]
          ]
        in '|'
          if x_speed == 0
            [
              [[1, 0], [x_pos + 1, y_pos]],
              [[-1, 0], [x_pos - 1, y_pos]],
            ]
          else
            [
              [[x_speed, y_speed], [x_pos + x_speed, y_pos + y_speed]]
            ]
          end
        in '-'
          if y_speed == 0
            [
              [[0, 1], [x_pos, y_pos + 1]],
              [[0, -1], [x_pos, y_pos - 1]],
            ]
          else
            [
              [[x_speed, y_speed], [x_pos + x_speed, y_pos + y_speed]]
            ]
          end
        in '/'
          if x_speed == 0 && y_speed == 1
            [
              [[-1, 0], [x_pos - 1, y_pos]]
            ]
          elsif x_speed == 0 && y_speed == -1
            [
              [[1, 0], [x_pos + 1, y_pos]]
            ]
          elsif x_speed == 1 && y_speed == 0
            [
              [[0, -1], [x_pos, y_pos - 1]]
            ]
          elsif x_speed == -1 && y_speed == 0
            [
              [[0, 1], [x_pos, y_pos + 1]]
            ]
          else
            raise 'unknown speed'
          end
        in '\\'
          if x_speed == 0 && y_speed == 1
            [
              [[1, 0], [x_pos + 1, y_pos]]
            ]
          elsif x_speed == 0 && y_speed == -1
            [
              [[-1, 0], [x_pos - 1, y_pos]]
            ]
          elsif x_speed == 1 && y_speed == 0
            [
              [[0, 1], [x_pos, y_pos + 1]]
            ]
          elsif x_speed == -1 && y_speed == 0
            [
              [[0, -1], [x_pos, y_pos - 1]]
            ]
          else
            raise 'unknown speed'
          end
        end

      curr_next_beams.reject! do |next_speed, next_position|
        energized.key?([next_speed, next_position]) || next_position[0] < 0 || next_position[0] >= $h || next_position[1] < 0 || next_position[1] >= $w
      end

      curr_next_beams.each do |next_speed, next_position|
        energized[[next_speed, next_position]] = true
      end

      next_beams += curr_next_beams
    end

    beams = next_beams
  end

  energized.keys.map { _1[1] }.uniq.count
end

# p1
p score([[0, 1], [0, 0]])

max = 0

# p2
(0...$h).each do |i|
  curr = score([[0, 1], [i, 0]])

  max = curr if curr > max
end

(0...$h).each do |i|
  curr = score([[0, -1], [i, $w - 1]])

  max = curr if curr > max
end

(0...$w).each do |j|
  curr = score([[1, 0], [0, j]])

  max = curr if curr > max
end

(0...$w).each do |j|
  curr = score([[-1, 0], [$h - 1, j]])

  max = curr if curr > max
end

p max
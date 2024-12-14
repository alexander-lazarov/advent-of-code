# frozen_string_literal: true

# input, w, h = File.read('input-sample.txt').lines, 11, 7
input, w, h = File.read('input.txt').lines, 101, 103

Robot = Data.define(:x, :y, :x_speed, :y_speed)

robots = input.map do |line|
  first, second = line.split(' ')
  x, y = first[2..].split(',').map(&:to_i)
  x_speed, y_speed = second[2..].split(',').map(&:to_i)

  Robot.new(x: x, y: y, x_speed: x_speed, y_speed: y_speed)
end

100.times do
  robots.map! do |robot|
    Robot.new(
      x: (robot.x + robot.x_speed) % w,
      y: (robot.y + robot.y_speed) % h,
      x_speed: robot.x_speed,
      y_speed: robot.y_speed
    )
  end
end

quadrant_x = (w - 1) / 2
quadrant_y = (h - 1) / 2

q1 = robots.count { _1.x > quadrant_x && _1.y > quadrant_y }
q2 = robots.count { _1.x < quadrant_x && _1.y > quadrant_y }
q3 = robots.count { _1.x < quadrant_x && _1.y < quadrant_y }
q4 = robots.count { _1.x > quadrant_x && _1.y < quadrant_y }

p q1 * q2 * q3 * q4

i = 100
loop do
  robots.map! do |robot|
    Robot.new(
      x: (robot.x + robot.x_speed) % w,
      y: (robot.y + robot.y_speed) % h,
      x_speed: robot.x_speed,
      y_speed: robot.y_speed
    )
  end

  break if robots.map { [_1.x, _1.y] }.uniq.size == robots.size

  i += 1
end

w.times do |y|
  h.times do |x|
    print(robots.any? { _1.x == x && _1.y == y } ? '#' : '.')
  end

  print "\n"
end

p i + 1


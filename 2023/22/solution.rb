# INPUT = 'input-sample.txt'
INPUT = 'input.txt'

bricks = File.read(INPUT).split("\n").map do |line|
  x1, y1, z1, x2, y2, z2 = line.split(/~|,/).map(&:to_i)

  x1, x2 = x2, x1 if x1 > x2
  y1, y2 = y2, y1 if y1 > y2
  z1, z2 = z2, z1 if z1 > z2

  {x: (x1..x2), y: (y1..y2), z: (z1..z2)}
end.sort_by { _1[:z].begin }

def projection_of(brick)
  if brick[:x].size != 1 then brick[:x].to_a.map { |x| [x, brick[:y].begin] }
  elsif brick[:y].size != 1 then brick[:y].to_a.map { |y| [brick[:x].begin, y] }
  else [[brick[:x].begin, brick[:y].begin]] end
end

def fall(bricks)
  result = []
  cubescape = Hash.new { 0 }
  bricks_fallen_count = 0

  bricks.each do |brick|
    projection = projection_of(brick)

    diff = brick[:z].begin - projection.map { |c| cubescape[c] }.max - 1

    bricks_fallen_count += 1 if diff > 0

    fallen_brick = brick.dup
    fallen_brick[:z] = (fallen_brick[:z].begin - diff)..(fallen_brick[:z].end - diff)
    result << fallen_brick

    projection.each { cubescape[_1] = fallen_brick[:z].end if fallen_brick[:z].end > cubescape[_1] }
  end

  [result, bricks_fallen_count]
end

bricks, _ = fall(bricks)

counts = []

bricks.count.times do |i|
  new_board = bricks.dup
  new_board.delete_at(i)

  counts << fall(new_board)[1]
end

p counts.count(&:zero?)
p counts.sum

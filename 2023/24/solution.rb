EPSILON = 1e-6
# INPUT, min, max = 'input-sample.txt', 7, 27
INPUT, min, max = 'input.txt', 200000000000000, 400000000000000

$stones = File.read(INPUT).split("\n").map do |line|
  pos, speed = line.split(' @ ')

  pos = pos.split(',').map(&:to_i)
  speed = speed.split(',').map(&:to_i)

  {position: pos, speed: speed}
end

def intersection_2(x1, y1, a, b, x2, y2, c, d)
  denominator = a*d - b*c

  return nil if denominator == 0

  t = (d*(x2 - x1) + c*(y1 - y2)) / denominator.to_f
  s = (a*(y2 - y1) + b*(x1 - x2)) / denominator.to_f

  intersect_x = x1 + a*t
  intersect_y = y1 + b*t

  return [intersect_x, intersect_y]
end

def normalize(v) = v.map { _1 / v[0].to_f }
def eql?(a, b) = a.zip(b).all? { (_1 - _2).abs < EPSILON }

count = 0

$stones.permutation(2).each do |stone1, stone2|
  intersection = intersection_2(
    stone1[:position][0], stone1[:position][1], stone1[:speed][0], stone1[:speed][1],
    stone2[:position][0], stone2[:position][1], stone2[:speed][0], stone2[:speed][1],
  )

  next unless intersection
  next unless intersection[0].between?(min, max) && intersection[1].between?(min, max)

  t1 = (intersection[0] - stone1[:position][0]) / stone1[:speed][0].to_f
  t2 = (intersection[0] - stone2[:position][0]) / stone2[:speed][0].to_f

  count += 1 if t1 > 0 && t2 > 0
end

p count / 2

t_max = $stones.size * 1_000

stone1 = $stones.sample
stone2 = $stones.sample
stone3 = $stones.sample

raise 'bad luck' if stone1 == stone2
raise 'bad luck' if stone1 == stone3
raise 'bad luck' if stone2 == stone3

(1000..t_max).each do |t1|
  pos1 = [stone1[:position][0] + stone1[:speed][0] * t1, stone1[:position][1] + stone1[:speed][1] * t1, stone1[:position][2] + stone1[:speed][2] * t1]

  (1..t_max).each do |t2|
    next if t1 == t2

    pos2 = [stone2[:position][0] + stone2[:speed][0] * t2, stone2[:position][1] + stone2[:speed][1] * t2, stone2[:position][2] + stone2[:speed][2] * t2]

    d12 = normalize [pos2[0] - pos1[0], pos2[1] - pos1[1], pos2[2] - pos1[2]]
    (2..t_max).each do |t3|
      next if t1 == t3 || t2 == t3

      pos3 = [stone3[:position][0] + stone3[:speed][0] * t3, stone3[:position][1] + stone3[:speed][1] * t3, stone3[:position][2] + stone3[:speed][2] * t3]

      d13 = normalize [pos3[0] - pos1[0], pos3[1] - pos1[1], pos3[2] - pos1[2]]

      if eql?(d12, d13)
        dt = t1 - t2
        speed = [(pos1[0] - pos2[0]) / dt.to_f, (pos1[1] - pos2[1]) / dt.to_f, (pos1[2] - pos2[2]) / dt.to_f]
        initial = [pos1[0] - t1*speed[0], pos1[1] - t1*speed[1], pos1[2] - t1*speed[2]]

        p "initial: #{initial.sum}"
      end
    end
  end
end
# INPUT = 'input-sample.txt'
INPUT = 'input.txt'

$graph = Hash.new { |h, k| h[k] = Array.new }
$edges = Hash.new(0)

File.read(INPUT).split("\n").each do |line|
  from, to = line.split(':')
  to = to.split(' ')

  to.each do
    $graph[from] << _1
    $graph[_1] << from
  end
end

$graph.keys.each do |start|
  visited = Set.new

  to_visit = [start]

  until to_visit.empty?
    current = to_visit.shift
    visited << current

    $graph[current].each do |to|
      next if visited.include?(to) || to_visit.include?(to)

      $edges[[current, to].sort] += 1

      to_visit << to
    end
  end
end

$edges.to_a.sort_by { -_2 }.map(&:first).combination(3).each do |combination|
  combination.each do
    $graph[_1].delete(_2)
    $graph[_2].delete(_1)
  end

  k = $graph.keys.first
  visited = Set.new
  to_visit = [k]

  until to_visit.empty?
    current = to_visit.shift
    visited << current

    $graph[current].each do |to|
      next if visited.include?(to) || to_visit.include?(to)

      to_visit << to
    end
  end

  a = ($graph.size - visited.size) * visited.size
  if a > 0
    puts a
    puts "need to delete #{combination}"
    break
  end

  combination.each do
    $graph[_1] << _2
    $graph[_2] << _1
  end
end

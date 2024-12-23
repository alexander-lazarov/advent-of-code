input = File.read('input.txt')
# input = File.read('input-sample.txt')

$computers = Set.new
$connections = {}

input.split("\n").each do |line|
  x, y = line.split('-')

  $computers.add x
  $computers.add y

  $connections[x] ||= Set.new
  $connections[x] << y
  $connections[y] ||= Set.new
  $connections[y] << x
end

three_cliques = Set.new
beginning_with_t = $computers.select { |c| c.start_with? 't' }

beginning_with_t.each do |a|
  $connections[a].each do |b|
    $connections[b].each do |c|
      next if a == c || a == b || b == c


      (three_cliques << [a, b, c].sort) if $connections[a].include?(c)
    end
  end
end

p three_cliques.size

$memo = {}
def largest_clique(to_check)
  $memo[to_check] ||=
    begin
      largest = Set.new

      to_check.each do |current_node|
        overlap = to_check & $connections[current_node]

        current_clique = largest_clique(overlap) + [current_node]

        if current_clique.size > largest.size
          largest = current_clique
        end
      end

      largest
    end
end

puts largest_clique($computers).to_a.sort.join(',')

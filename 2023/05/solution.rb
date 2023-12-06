INPUT = 'input-sample.txt'
INPUT = 'input.txt'

def map_from(map, input)
  map.each do |m|
    diff = input - m[:from]

    if diff >= 0 && diff <= m[:len]
      return m[:start] + diff
    end
  end

  input
end

sections = File.read(INPUT).split("\n\n")

seeds = sections[0].split(":")[1].split(" ").map(&:to_i)

maps = sections.drop(1).map do |section|
  section.split("\n").drop(1).map do |line|
    line.split(" ").map(&:to_i)
  end.map do |start, from, len|
    { from: from, start: start, len: len}
  end
end

# pp seeds
# pp maps

def seed_through_maps(seed, maps)
  current = seed
  i = 0

  maps.each do |map|
    i += 1
    current = map_from(map, current)
  end

  current
end

# def slice_through_map(range, maps)

# end

def slice_through_map(range, map)
  from, to = range
end

mapped = seeds.map do |seed|
  seed_through_maps(seed, maps)
end

pp mapped.min

# min_seed = seeds[0]
# min = seed_through_maps(seeds[0], maps)

# (seeds.size / 2).times do |i|
#   pp "Trying pair #{i}"
#   (seeds[i * 2]..seeds[i * 2 + 1]).each do |seed|
#     r = seed_through_maps(seed, maps)

#     if r < min
#       min = r
#       min_seed = seed
#     end
#   end
# end

# pp min
# pp min_seed
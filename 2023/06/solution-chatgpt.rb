# Prompt: https://chat.openai.com/share/f7c1faee-247f-40b5-93ff-4695a1ac7953

# Read the input from the file and split into two lines
lines = File.readlines("input.txt").map(&:strip)
times_line = lines[0].gsub('Time:', '')
distances_line = lines[1].gsub('Distance:', '')

def calculate_ways(time, record_distance)
  ways = 0
  # Iterate over the possible button hold times
  (0...time).each do |hold_time|
    # Calculate the remaining time and the distance
    remaining_time = time - hold_time
    speed = hold_time
    total_distance = remaining_time * speed

    # Check if this beats the record
    ways += 1 if total_distance > record_distance
  end
  ways
end

# Process for Part 1 (multiple races)
times = times_line.split.map(&:to_i)
distances = distances_line.split.map(&:to_i)
part1_results = times.zip(distances).map { |time, distance| calculate_ways(time, distance) }
part1_total_ways = part1_results.reduce(:*)

# Process for Part 2 (single long race)
single_time = times_line.gsub(' ', '').to_i
single_distance = distances_line.gsub(' ', '').to_i
part2_total_ways = calculate_ways(single_time, single_distance)

puts "Part 1 Total ways to win: #{part1_total_ways}"
puts "Part 2 Total ways to win: #{part2_total_ways}"

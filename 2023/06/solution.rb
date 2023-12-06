# INPUT = 'input-sample.txt'
INPUT = 'input.txt'

sections = File.read(INPUT).split("\n")

times = sections[0].scan(/\d+/).map(&:to_i)
distances = sections[1].scan(/\d+/).map(&:to_i)

def distance_for_charge_time(total_time, charge_time) = (total_time - charge_time) * charge_time

ways = times.zip(distances).map do |time, distance|
  (0..time).count do |charge_time|
    distance_for_charge_time(time, charge_time) > distance
  end
end

puts "Part 1: #{ways.reduce(:*)}"

time_2 = sections[0].scan(/\d/).join.to_i
distance_2 = sections[1].scan(/\d/).join.to_i

p2 = (0..time_2).count do |charge_time|
  puts "Progress: #{charge_time}/#{time_2}" if (charge_time % 1_000_000).zero?
  distance_for_charge_time(time_2, charge_time) > distance_2
end

puts "Part 2: #{p2}"
# This is ChatGPT generated solution
# You can see the prompt here: https://chat.openai.com/share/a77a3f52-3795-480e-a90e-46b02aee7e43

# Define the maximum number of cubes for each color
MAX_RED = 12
MAX_GREEN = 13
MAX_BLUE = 14

# Function to check if a game is possible
def is_game_possible(game_data)
  game_data.each do |round|
    return false if round[:red] > MAX_RED || round[:green] > MAX_GREEN || round[:blue] > MAX_BLUE
  end
  true
end

# Function to find the minimum cubes for each color in a game
def find_minimum_cubes(game_data)
  min_red = min_green = min_blue = 0
  game_data.each do |round|
    min_red = [min_red, round[:red]].max
    min_green = [min_green, round[:green]].max
    min_blue = [min_blue, round[:blue]].max
  end
  { red: min_red, green: min_green, blue: min_blue }
end

# Function to calculate the power of a set of cubes
def calculate_power(cubes)
  cubes[:red] * cubes[:green] * cubes[:blue]
end

# Read the input from the file
input = File.read('input.txt')

# Process each game
sum_of_ids = 0
total_power = 0
input.each_line do |line|
  game_id, data = line.split(':')
  game_id = game_id[/\d+/].to_i

  # Parse the rounds data
  rounds = data.split(';').map do |round|
    red = round.scan(/(\d+) red/).flatten.first.to_i
    green = round.scan(/(\d+) green/).flatten.first.to_i
    blue = round.scan(/(\d+) blue/).flatten.first.to_i
    { red: red, green: green, blue: blue }
  end

  # Check if the game is possible and update the sum
  sum_of_ids += game_id if is_game_possible(rounds)

  # Find minimum cubes and calculate power
  min_cubes = find_minimum_cubes(rounds)
  total_power += calculate_power(min_cubes)
end

# Print the results
puts "Sum of game IDs: #{sum_of_ids}"
puts "Total power of minimum sets: #{total_power}"
# https://chat.openai.com/share/db593917-2a32-49a9-b555-34a22420f4fc
# Function to replace the first spelled-out digit from the start and end of the line
def replace_spelled_digits(line)
  spelled_digits = {
    'one' => '1', 'two' => '2', 'three' => '3', 'four' => '4',
    'five' => '5', 'six' => '6', 'seven' => '7', 'eight' => '8', 'nine' => '9'
  }

  # Replace the first occurrence from the start
  spelled_digits.each do |word, digit|
    if line.include?(word)
      line.sub!(word, digit)
      break
    end
  end

  # Replace the first occurrence from the end
  spelled_digits.to_a.reverse.each do |word, digit|
    if line.reverse.include?(word.reverse)
      line.reverse!.sub!(word.reverse, digit)
      line.reverse!
      break
    end
  end

  line
end

# Function to extract the calibration value from a line
def extract_calibration_value(line)
  line = replace_spelled_digits(line)
  first_digit = line[/\d/]
  last_digit = line.reverse[/\d/]
  return 0 unless first_digit && last_digit  # Return 0 if no digits found

  (first_digit + last_digit).to_i
end

# Function to calculate the total calibration value from an array of lines
def calculate_total_calibration(lines)
  lines.sum { |line| extract_calibration_value(line) }
end

# Example input
lines = [
  "two1nine",
  "eightwothree",
  "abcone2threexyz",
  "xtwone3four",
  "4nineeightseven2",
  "zoneight234",
  "7pqrstsixteen"
]

# Calculate and print the total calibration value
total_calibration = calculate_total_calibration(lines)
puts "Total calibration value: #{total_calibration}"

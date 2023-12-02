# Prompt: https://chat.openai.com/share/db593917-2a32-49a9-b555-34a22420f4fc
# Function to extract the calibration value from a line
def extract_calibration_value(line)
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
  "1abc2",
  "pqr3stu8vwx",
  "a1b2c3d4e5f",
  "treb7uchet"
]

# Calculate and print the total calibration value
total_calibration = calculate_total_calibration(lines)
puts "Total calibration value: #{total_calibration}"

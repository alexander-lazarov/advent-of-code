DIV = 20201227

def transform(current_value, subject_value)
  current_value *= subject_value

  current_value %= DIV
end

def loop_size(public_key, subject)
  current = 1

  i = 0

  loop do
    current = transform(current, subject)
    i+= 1

    break if current == public_key
  end

  i
end

def apply_transform(subject_value, loop_size)
  current = 1

  loop_size.times do
    current = transform(current, subject_value)
  end

  current
end

public_key1 = 8987316
public_key2 = 14681524

loop_size1 = loop_size(public_key1, 7)
loop_size2 = loop_size(public_key2, 7)

puts apply_transform(public_key2, loop_size1)

# INPUT = 'input-sample.txt'
INPUT = 'input.txt'
steps = File.read(INPUT).split(',')

def hash(str) = str.chars.inject(0) { (_1 + _2.ord) * 17 % 256 }

p steps.sum { hash(_1) }

boxes = {}

steps.each do |step|
  str_label, sign, focal_length = step.scan(/^(\w+)(\-|=)(\d*)$/)[0]
  focal_length = focal_length.to_i if focal_length
  label = hash(str_label)

  case sign
  in '-'
    if boxes[label]
      boxes[label].reject! { _1[0] == str_label }

      boxes.delete(label) if boxes[label].empty?
    end
  in '='
    if boxes[label]
      if i = boxes[label].find_index { _1[0] == str_label }
        boxes[label][i][1] = focal_length
      else
        boxes[label] << [str_label, focal_length]
      end
    else
      boxes[label] = [[str_label, focal_length]]
    end
  end
end

sum = 0

boxes.each do |box_num, lenses|
  lenses.each_with_index do |(_, focal_length), lens_num|
    sum += (box_num + 1) * (lens_num + 1) * focal_length
  end
end

p sum
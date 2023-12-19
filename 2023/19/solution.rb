# INPUT = 'input-sample.txt'
INPUT = 'input.txt'

halves = File.read(INPUT).split("\n\n")

workflows = halves[0].split("\n").map do |line|
  name, rest = line.split('{')

  rest = rest[0..-2].split(',').map do |rule|
    case rule
    in 'A' | 'R' then rule
    in /^([xmas])(\>|\<)(\d+)\:(\w+)$/
      [Regexp.last_match[1], Regexp.last_match[2], Regexp.last_match[3].to_i, Regexp.last_match[4]]
    in /^\w+$/ then rule
    end
  end

  [name, rest]
end.to_h

parts = halves[1].split("\n").map do |line|
  props = line[1..-2].split(',').map { |p| l, r = p.split('='); [l, r.to_i] }.to_h
end

def part_value(part, workflows, workflow_name)
  workflow = workflows[workflow_name]

  workflow.each do |rule|
    if rule.is_a?(Array)
      prop, op, value, next_workflow = rule

      lval = part[prop]

      cmp = if op == '>'
              lval > value
            elsif op == '<'
              lval < value
            else
              raise "Unknown op #{op}"
            end

      if cmp
        case next_workflow
        in 'A' then return part.sum { |k, v| v }
        in 'R' then return 0
        else return part_value(part, workflows, next_workflow)
        end
      else
        next
      end
    else
      if rule == 'A'
        return part.sum { |k, v| v }
      elsif rule == 'R'
        return 0
      else
        return part_value(part, workflows, rule)
      end
    end
  end
end

pp parts.sum { |part| part_value(part, workflows, 'in') }

terminated = []

queue = [
  [{
    'x' => (1..4000),
    'm' => (1..4000),
    'a' => (1..4000),
    's' => (1..4000),
  }, 'in']
]

until queue.empty?
  current = queue.shift

  part, workflow_name = current

  workflow = workflows[workflow_name]

  workflow.each do |rule|
    if rule.is_a?(Array)
      prop, op, value, next_workflow = rule

      true_part = part.dup
      false_part = part.dup

      if op == '>'
        true_part[prop] = (value + 1)..part[prop].end
        false_part[prop] = part[prop].begin..value
      elsif op == '<'
        true_part[prop] = part[prop].begin..(value - 1)
        false_part[prop] = value..part[prop].end
      else
        raise "Unknown op #{op}"
      end

      if false_part[prop].begin <= false_part[prop].end
        part = false_part
      else
        break
      end

      if true_part[prop].begin <= true_part[prop].end
        if next_workflow == 'A' || next_workflow == 'R'
          terminated << [true_part, next_workflow]
        else
          queue << [true_part, next_workflow]
        end
      end
    else
      if rule == 'A' || rule == 'R'
        terminated << [part, rule]
      else
        queue << [part, rule]
      end
    end
  end
end

p terminated.select { |part, workflow_name| workflow_name == 'A' }.map { |part, _| part.values.map(&:size).reduce(:*) }.sum
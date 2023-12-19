# INPUT = 'input-sample.txt'
INPUT = 'input.txt'

$workflows, parts = File.read(INPUT).split("\n\n")

$workflows = $workflows.split("\n").map do |line|
  name, rules = line.scan(/^(\w+)\{(.+)\}$/)[0]

  rules = rules.split(',').map do
    case _1
    in /^([xmas])(\>|\<)(\d+)\:(\w+)$/ then [$1, $2, $3.to_i, $4]
    in /^\w+$/ then _1
    end
  end

  [name, rules]
end.to_h

parts = parts.split("\n").map do |line|
  props = line[1..-2].split(',').map { l, r = _1.split('='); [l, r.to_i] }.to_h
end

def part_value(part, workflow_name)
  $workflows[workflow_name].each do |rule|
    case rule
    in Array
      prop, op, value, next_workflow = rule

      next unless op == '>' ? part[prop] > value : part[prop] < value

      case next_workflow
      in 'A' then return part.values.sum
      in 'R' then return 0
      else return part_value(part, next_workflow)
      end
    in 'A' then return part.values.sum
    in 'R' then return 0
    else return part_value(part, rule)
    end
  end
end

p parts.sum { |part| part_value(part, 'in') }

e = []
queue = [[{'x' => (1..4000), 'm' => (1..4000), 'a' => (1..4000), 's' => (1..4000),}, 'in']]

until queue.empty?
  part, workflow_name = queue.shift

  $workflows[workflow_name].each do |rule|
    case rule
    in Array
      prop, op, value, next_workflow = rule
      t, f = part.dup, part.dup

      case op
      in '>'
        t[prop] = (value + 1)..part[prop].end
        f[prop] = part[prop].begin..value
      in '<'
        t[prop] = part[prop].begin..(value - 1)
        f[prop] = value..part[prop].end
      end

      case next_workflow
      in 'A'| 'R' then e << [t, next_workflow]
      else queue << [t, next_workflow]
      end

      part = f
    in 'A' | 'R' then e << [part, rule]
    else queue << [part, rule]
    end
  end
end

p e.select { _2 == 'A' }.map { _1[0].values.map(&:size).reduce(:*) }.sum
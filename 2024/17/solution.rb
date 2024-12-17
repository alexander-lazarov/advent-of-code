# frozen_string_literal: true

# input = File.read('input-sample.txt')
input = File.read('input.txt')


registers, memory = input.split("\n\n")
memory = memory.split(':')[1].strip.split(',').map(&:to_i)
registers = registers.split("\n").map { _1.split(':')[1].to_i }

def exec_program(memory, registers)
  pc = 0

  output = []

  while pc < memory.size
    opcode = memory[pc]
    operand = memory[pc + 1]
    combo_operand = case operand
               in 0..3 then operand
               in 4..6 then registers[operand - 4]
               end

    case opcode
    in 0 then registers[0] = registers[0] / 2.pow(combo_operand)
    in 1 then registers[1] = registers[1] ^ operand
    in 2 then registers[1] = combo_operand % 8
    in 3
      unless registers[0].zero?
        pc = operand
        next
      end
    in 4 then registers[1] = registers[1] ^ registers[2]
    in 5 then output << combo_operand % 8
    in 6 then registers[1] = registers[0] / 2.pow(combo_operand)
    in 7 then registers[2] = registers[0] / 2.pow(combo_operand)
    end

    pc += 2
  end

  output
end

puts exec_program(memory, registers).join(',')

queue = [[ 1, 0 ]]

found = false

until queue.empty?
  length, current = queue.shift

  break if found

  (current..(current+7)).each do |candidate|
    output = exec_program(memory, [candidate, 0, 0])

    if output == memory.last(length)
      queue << [length + 1, candidate << 3]

      if length == memory.size
        puts candidate
        found = true

        break
      end
    end
  end
end


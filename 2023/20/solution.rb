# INPUT = 'input-sample.txt'
INPUT = 'input.txt'

def read_input
  board = File.read(INPUT).split("\n").map { _1.split(' -> ') }.map do |from, to|
    type, name = case from[0]
                in '&' then [:conj, from[1..]]
                in '%' then [:flipflop, from[1..]]
                else [:normal, from]
                end

    type = :broadcaster if name == 'broadcaster'

    [name, {type:, memory: (type == :flipflop ? :low : Hash.new {:low }), to: to.split(', ') }]
  end.to_h

  board.each do |name, mod|
    mod[:to].each do |to|
      if board[to] && board[to][:type] == :conj
        board[to][:memory][name] = :low
      end
    end
  end

  board
end

low, high = 0, 0

board = read_input

1_000.times do
  queue = [['button', 'broadcaster', :low]]

  loop do
    break if queue.empty?

    from, to, signal = queue.shift
    if signal == :low then low += 1 else high += 1 end

    mod = board[to]

    next unless mod

    case mod[:type]
    when :broadcaster then mod[:to].each { |receiver| queue.push [to, receiver, :low] }
    when :conj
      mod[:memory][from] = signal

      to_send = mod[:memory].values.all? { _1 == :high } ? :low : :high

      mod[:to].each { |receiver| queue.push [to, receiver, to_send] }
    when :flipflop
      next unless signal == :low

      mod[:memory] =  mod[:memory] == :low ? :high : :low
      mod[:to].each { |receiver| queue.push [to, receiver, mod[:memory]] }
    end
  end
end

p low * high

# reset the board
board = read_input

# you need to fill in the targets manually
# inspect the input and look for the node connected to rx
# then look for the nodes connected to that node and fill in the ones below
# in theory this can be done programatically, but I'm too lazy to do this :)
targets = %w(xj qs kz km)
iterations = [nil, nil, nil, nil]

1_000_000.times do |i|
  queue = [['button', 'broadcaster', :low]]

  loop do
    break if queue.empty?

    from, to, signal = queue.shift
    if signal == :low then low += 1 else high += 1 end

    if signal == :low && targets.include?(to)
      index = targets.index(to)
      iterations[index] ||= i + 1
    end

    mod = board[to]

    next unless mod

    case mod[:type]
    when :broadcaster then mod[:to].each { |receiver| queue.push [to, receiver, :low] }
    when :conj
      mod[:memory][from] = signal

      to_send = mod[:memory].values.all? { _1 == :high } ? :low : :high

      mod[:to].each { |receiver| queue.push [to, receiver, to_send] }
    when :flipflop
      next unless signal == :low

      mod[:memory] =  mod[:memory] == :low ? :high : :low
      mod[:to].each { |receiver| queue.push [to, receiver, mod[:memory]] }
    end
  end

  break if iterations.all?
end

p iterations.reduce(:lcm)
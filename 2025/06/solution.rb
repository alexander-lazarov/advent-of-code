input = 'input.txt'
# input = 'input-sample.txt'

p File.
    readlines(input).
    map { it.strip.split(/\ +/) }.
    transpose.
    sum { it[0..-2].map(&:to_i).reduce(it.last.to_sym) }

p File.
    readlines(input).
    map(&:chars).
    transpose.
    map(&:join).
    map(&:strip).
    join("\n").
    split("\n\n").
    map { it.split("\n") }.
    sum { it.map(&:to_i).reduce(it.first[-1].to_sym) }

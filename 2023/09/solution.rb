# INPUT = 'input-sample.txt'
INPUT = 'input.txt'

def next_seq_row(s) = s[1..].zip(s).map { _1 - _2 }
def seq_pyramid(seq)
  result = [seq.dup]
  result << next_seq_row(result.last) until result.last.all? &:zero?
  result
end
def seq_value(sequence) = seq_pyramid(sequence).sum { _1[-1] }

seqs = File.read(INPUT).split("\n").map { _1.split(' ').map(&:to_i) }
p seqs.sum { seq_value(_1) }
p seqs.sum { seq_value(_1.reverse) }
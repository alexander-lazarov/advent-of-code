# INPUT = 'input-sample.txt'
INPUT = 'input.txt'
mx = (12..14).to_a
games = Hash[File.readlines(INPUT).map { |l|
  m = l.match(/^Game (\d+):(.+)$/)
  t = m[2].split(';').map(&:strip).map { |t| Hash[t.split(', ').map { |r| num, col = r.split(' '); [col[0], num.to_i] }] }
  [m[1].to_i, %w(r g b).map { |c| t.map { _1[c] || 0 }.max } ]
}]
r = games.map { |i, t| [t.zip(mx).all? { _1 <= _2 } ? i : 0, t.reduce(:*)] }
2.times { |i| puts "Part #{i+1}: #{r.sum{ _1[i]}}" }
input = File.read('input.txt')

blobs = input.split("\n\n").map { _1.split("\n").map(&:strip).map(&:chars) }

locks = blobs.filter { _1[0].join.start_with?('###') }.map(&:transpose).map { |lock| lock.map { _1.count('#') - 1 } }

keys = blobs.filter { _1[0].join.start_with?('...') }.map(&:transpose).map { |key| key.map { _1.count('#') - 1 } }

p (keys.sum do |key|
  locks.count do |lock|
    key.zip(lock).all? { _1 + _2 <= 5 }
  end
end)

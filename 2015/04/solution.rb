key = 'iwrupvqb'

require 'digest'

(1..).each do |i|
  res = Digest::MD5.hexdigest "#{key}#{i}"

  if res =~ /^00000/
    puts i
    break
  end
end

(1..).each do |i|
  res = Digest::MD5.hexdigest "#{key}#{i}"

  if res =~ /^000000/
    puts i
    break
  end
end

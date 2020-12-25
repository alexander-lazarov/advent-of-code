d = 20201227

transform :: Int -> Int -> Int
transform current subject = (current * subject) `rem` d

transforms :: Int -> [Int]
transforms subject = iterate (transform subject) 1

loopSize :: Int -> Int -> Int
loopSize publicKey subject =
    snd n
  where
    n = last $ takeWhile (\(x, y) -> x /= publicKey) $ enumerate $ transforms subject

enumerate :: [a] -> [(a, Int)]
enumerate list = zip list [1..]

solution :: Int -> Int -> Int
solution publicKey1 publicKey2 =
    last $ take (loop1size + 1) $ transforms publicKey2
  where
    loop1size = loopSize publicKey1 7

main = do
  putStr $ "Part 1 answer is: "
  putStr $ show $ solution 8987316 14681524
  putStr "\n"

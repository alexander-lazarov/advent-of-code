import System.IO

filename = "input.txt"

split :: Char -> String -> [String]
split d [] = []
split d str =
    x : split d (drop 1 y)
  where
    (x, y) = span (/= d) str

strToBuses :: String -> [(Int, Int)]
strToBuses contents =
    [ (x `mod` (read y), read y) | (x, y) <- buses, y /= "x" ]
  where
    buses = zip [0..] $ split ',' contents

minByThird :: Ord c => (a, b, c) -> (a, b, c) -> (a, b, c)
minByThird (a1, b1, c1) (a2, b2, c2) = if c1 < c2
                                       then (a1, b1, c1)
                                       else (a2, b2, c2)

waitTimes :: [(Int, Int)] -> Int -> [(Int, Int, Int)]
waitTimes buses time =
    map waitTime buses
  where
    waitTime (id, line) = (id `mod` line, line, (line - (time `mod` line)) `mod` line)

solution1 :: String -> Int
solution1 contents =
   line * wait
 where
   firstLine = head $ lines contents
   secondLine = head $ tail $ lines contents
   timestamp = read firstLine :: Int
   buses = strToBuses secondLine
   waits = waitTimes buses timestamp
   (_, line, wait) = foldr1 minByThird waits

solution2 :: String -> Int
solution2 contents =
    solution2' buses 1
  where
    secondLine = head $ tail $ lines contents
    buses = strToBuses secondLine

solution2' :: [(Int, Int)] -> Int -> Int
solution2' buses guess =
    if answerIsCorrect
    then guess
    else solution2' buses (guess + increment)
  where
    waits = waitTimes buses guess
    guessedWaits = [ line | (id, line, wait) <- waits, wait == id]
    answerIsCorrect = length guessedWaits == length buses
    increment = foldr (*) 1 guessedWaits

main = do
  handle <- openFile filename ReadMode
  contents <- hGetContents handle

  putStr "Task 1 result is: "
  putStr $ show $ solution1 contents
  putStr "\n"
  putStr "Task 2 result is: "
  putStr $ show $ solution2 contents
  putStr "\n"

  hClose handle

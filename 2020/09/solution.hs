import System.IO
import qualified Data.Text as T

filename = "input.txt"

strToNum :: String -> Int
strToNum = read

nums :: [String] -> [Int]
nums contents = map strToNum contents

preambuleLength = 25

preambule :: [Int] -> [Int]
preambule = take preambuleLength

target :: [Int] -> Int
target xs = head $ drop preambuleLength xs

testSum1 :: Int -> [Int] -> Bool
testSum1 x xs = [] /= [(i, j) | i <- xs, j <- xs, i /= j, i + j == x]

cut :: Int -> Int -> [Int] -> [Int]
cut i j xs = take (j - i) $ (drop i xs)

solution1 :: [Int] -> Int
solution1 xs = case testSum1 (target xs) (preambule xs) of False -> target xs
                                                           True -> solution1 $ tail xs

solution2 :: [Int] -> Int
solution2 xs =
  solMin + solMax
  where
    l = length xs
    target = solution1 xs
    ranges = [ cut i j xs | i <- [0..l], j <-[i..l] ]
    targetRanges = filter (\range -> sum range == target) ranges
    sol = head targetRanges
    solMin = foldr1 min sol
    solMax= foldr1 max sol


main = do
  handle <- openFile filename ReadMode
  contents <- hGetContents handle

  putStr "Task 1 result is: "
  putStr $ show (solution1 $ nums $ lines contents) ++ "\n"
  putStr "Task 2 result is: "
  putStr $ show (solution2 $ nums $ lines contents) ++ "\n"

  hClose handle


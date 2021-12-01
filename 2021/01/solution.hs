import System.IO

filename = "input.txt"

nums :: [String] -> [Int]
nums contents = map read contents

triples :: [Int] -> [(Int, Int, Int)]
triples nums =
  zip3 nums (tail nums) (tail $ tail nums)

sum3 :: [(Int, Int, Int)] -> [Int]
sum3 = map (\(a, b, c) -> a + b + c)

pairs :: [Int] -> [(Int, Int)]
pairs nums = zip nums $ tail nums

task1 :: [String] -> Int
task1 contents = length $ filter (\(x, y) -> x < y) (pairs $ nums contents)

task2 :: [String] -> Int
task2 contents = length $ filter (\(x, y) -> x < y) (pairs $ sum3 $ triples $ nums contents)

main = do
  handle <- openFile filename ReadMode
  contents <- hGetContents handle

  putStr "Task 1 result is: \n"
  putStr $ show $ task1 $ lines contents
  putStr "\n"
  putStr "Task 2 result is \n"
  putStr $ show $ task2 $ lines contents
  putStr "\n"

  hClose handle

import System.IO

filename = "input.txt"

count_brackets :: Int -> Char -> Int
count_brackets acc '(' = acc + 1
count_brackets acc ')' = acc - 1
count_brackets acc _ = acc

task_1 :: [Char] -> Int
task_1 xs = foldl count_brackets 0 xs

task_2 :: [Char] -> Int
task_2 xs = length $ takeWhile (>=0) $ scanl count_brackets 0 xs

main = do
  handle <- openFile filename ReadMode
  contents <- hGetContents handle

  putStr "Task 1 result is: \n"
  putStr $ show $ task_1 contents
  putStr "\n"

  putStr "Task 2 result is: \n"
  putStr $ show $ task_2 contents
  putStr "\n"

  hClose handle

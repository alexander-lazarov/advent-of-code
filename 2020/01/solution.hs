import System.IO

filename = "input.txt"

nums :: [String] -> [Int]
nums contents = map read contents

solution :: Int -> Int -> [Int] -> Maybe Int
solution _ _      []     = Nothing
solution 1 target (x:xs) = if (target == x)
                           then Just target
                           else solution 1 target xs
solution n target (x:xs) = case (solution (n -1) (target - x) xs) of Nothing -> solution n target xs
                                                                     Just a  -> Just (x * a)

main = do
  handle <- openFile filename ReadMode
  contents <- hGetContents handle

  putStr "Task 1 result is: "
  putStr $ show (solution 2 2020 (nums $ lines contents)) ++ "\n"
  putStr "Task 2 result is: "
  putStr $ show (solution 3 2020 (nums $ lines contents)) ++ "\n"

  hClose handle


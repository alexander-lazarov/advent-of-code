import System.IO

filename = "input.txt"

height :: [String] -> Int
height = length

width :: [String] -> Int
width grid = length $ grid !! 0

isTree :: [String] -> Int -> Int -> Bool
isTree grid x y =
  let
      i = x `mod` (height grid)
      j = y `mod` (width grid)
  in
    if i >= height grid
    then False
    else grid !! i !! j == '#'

treesForSlope :: [String] -> Int -> Int -> Int -> Int -> Int
treesForSlope grid x y i j =
  if i >= height grid
  then 0
  else if isTree grid i j
       then 1 + next
       else next
  where
    next = treesForSlope grid x y (i + x) (j + y)

slopes = [(1, 1), (1, 3), (1, 5), (1, 7), (2, 1)]

result_1 grid =
  treesForSlope grid 1 3 0 0

result_2 grid =
   foldr (*) 1 counts
   where counts = fmap f slopes
         f (i, j) = treesForSlope grid i j 0 0

main = do
  handle <- openFile filename ReadMode
  contents <- hGetContents handle

  putStr "Task 1 result is: "
  putStr $ show $ result_1 (lines contents)
  putStr "\n"
  putStr "Task 2 result is: "
  putStr $ show $ result_2 (lines contents)
  putStr "\n"

  hClose handle

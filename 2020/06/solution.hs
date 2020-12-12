import System.IO
import Text.Parsec
import Text.Parsec.String

filename = "input.txt"

personAnswers :: Parser String
personAnswers = do
  answer <- many1 alphaNum
  char '\n'
  return answer

groupAnswers :: Parser [String]
groupAnswers = do
  answers <- many1 personAnswers
  char '\n'
  return answers

allGroups :: Parser [[String]]
allGroups = do
  str <- many1 groupAnswers
  char '\n'
  return str

parseInput :: String -> [[String]]
parseInput s = let
  parsed = parse allGroups "" s
  in
  case parsed of Left e  -> []
                 Right p -> p

inStr :: Eq a => a -> [a] -> Bool
inStr _ [] = False
inStr a (x:xs) = if a == x
                 then True
                 else inStr a xs

dedup :: Eq a => [a] -> [a]
dedup     [] = []
dedup (x:xs) = case inStr x xs of True -> dedup xs
                                  False -> x:(dedup xs)

anyAnswersCount :: [String] -> Int
anyAnswersCount xs = length $ dedup $ foldr1 (++) xs

intersectAnswersCount :: [String] -> Int
intersectAnswersCount xs = length $ dedup $ foldr1 (intersect) xs

intersect :: Eq a => [a] -> [a] -> [a]
intersect [] _ = []
intersect _ [] = []
intersect (x:xs) ys = case inStr x ys of True  -> x:(intersect xs ys)
                                         False -> intersect xs ys


solution1 :: [[String]] -> Int
solution1 gs = foldr1 (+) $ map anyAnswersCount gs

solution2 :: [[String]] -> Int
solution2 gs = foldr1 (+) $ map intersectAnswersCount gs

main = do
  handle <- openFile filename ReadMode
  contents <- hGetContents handle

  putStr "Task 1 result is: "
  putStr $ (show $ solution1 $ parseInput $ contents ++ "\n") ++ "\n"
  putStr "Task 2 result is: "
  putStr $ (show $ solution2 $ parseInput $ contents ++ "\n") ++ "\n"

  hClose handle


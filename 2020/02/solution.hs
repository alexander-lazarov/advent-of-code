import System.IO
import Text.Parsec
import Text.Parsec.String

data PasswordInfo = PasswordInfo {
      i :: Int,
      j :: Int,
      c :: Char,
      password :: String
   } deriving Show
-- Represents a row from the input
-- 1-3 a: abcde
-- | | |  |
-- | | |  +- password
-- | | +---- c
-- | +------ j
-- +---------i

passwordInfo :: Parser PasswordInfo
passwordInfo = do
  istr <- many1 digit
  char '-'
  jstr <- many1 digit
  char ' '
  c <- anyChar
  char ':'
  char ' '
  password <- many1 alphaNum

  return $ PasswordInfo (read istr) (read jstr) c password

passwordInfos :: Parser [PasswordInfo]
passwordInfos = do
  many1 (do
    pwdInfo <- passwordInfo
    option '_' $ endOfLine

    return pwdInfo)

parseInput :: String -> [PasswordInfo]
parseInput s = let
  parsed = parse passwordInfos "" s
  in
  case parsed of Left e  -> []
                 Right p -> p

count_if :: (a -> Bool) -> [a] -> Int
count_if p = length . filter p

solution_1 :: [PasswordInfo] -> Int
solution_1 = count_if valid_1

solution_2 :: [PasswordInfo] -> Int
solution_2 = count_if valid_2

valid_1 :: PasswordInfo -> Bool
valid_1 PasswordInfo{i=i, j=j, c=c, password=password} =
    i <= count && count <= j
  where
    count = count_if (==c) password

valid_2 :: PasswordInfo -> Bool
valid_2 PasswordInfo{i=i, j=j, c=c, password=password} =
    i_is_there /= j_is_there
  where
    i_is_there = password !! (i - 1) == c
    j_is_there = password !! (j - 1) == c

filename = "input.txt"

main = do
  handle <- openFile filename ReadMode
  contents <- hGetContents handle

  putStr "Task 1 result is: "
  putStr $ (show $ solution_1 $ parseInput contents) ++ "\n"
  putStr "Task 2 result is: "
  putStr $ (show $ solution_2 $ parseInput contents) ++ "\n"

  hClose handle


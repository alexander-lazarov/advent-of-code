import System.IO

data Seat = Seat {
     row :: Int,
     col :: Int
  } deriving Show

stringToSeat :: String -> Seat
stringToSeat seat =
    Seat row col
  where
    row = strToBin $ reverse $ take 7 seat
    col = strToBin $ reverse $ drop 7 seat

seatID :: Seat -> Int
seatID Seat{row=row, col=col} = row * 8 + col

strToBin :: String -> Int
strToBin str =
    binToInt $ ints
  where
    ints = map valueOf str


binToInt :: [Int] -> Int
binToInt ([]) = 0
binToInt (x:[]) = x
binToInt (x:xs) = x + 2 * (binToInt xs)

trim0 :: [Int] -> [Int]
trim0 []     = []
trim0 (x:[]) = [x]
trim0 (0:xs) = trim0 xs
trim0 xs     = xs

valueOf :: Char -> Int
valueOf 'B' = 1
valueOf 'R' = 1
valueOf 'F' = 0
valueOf 'L' = 0
valueOf _   = undefined

solution1 :: String -> Int
solution1 contents =
    foldr1 max seatIds
  where
    seatIds = map seatID seats
    seats = map stringToSeat contentLines
    contentLines = lines contents

solution2 :: String -> Int
solution2 contents =
    foldr1 max [id | id <- [minId..maxId], not $ elem id seatIds]
  where
    seatIds = map seatID seats
    seats = map stringToSeat contentLines
    contentLines = lines contents
    minId = foldr1 min seatIds
    maxId = foldr1 max seatIds

filename = "input.txt"

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

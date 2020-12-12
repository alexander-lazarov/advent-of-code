import System.IO

filename = "input.txt"

data Seat = Floor | Occupied | Empty deriving (Eq)
type Board = [[Seat]]

toSeat :: Char -> Seat
toSeat '#' = Occupied
toSeat 'L' = Empty
toSeat '.' = Floor
toSeat _   = undefined

toBoard :: [String] -> Board
toBoard = map (map toSeat)

width :: Board -> Int
width = length

height :: Board -> Int
height = length . head

safeGet :: Int -> [a] -> Maybe a
safeGet  _ []    = Nothing
safeGet 0 (x:xs) = Just x
safeGet i (x:xs) = safeGet (i - 1) xs

safeGet2 :: (Int, Int) -> [[a]] -> Maybe a
safeGet2 (x, y) xs = safeGet x xs >>= safeGet y

takenNeighbors :: Int -> Int -> Board -> Int
takenNeighbors x y b =
     length takenSeats
   where
     takenSeats = filter (== Just Occupied) seats
     seats = map (\(x, y) -> safeGet2 (x, y) b) neighbors
     neighbors = [(x - 1, y - 1)
                 ,(x     ,y - 1)
                 ,(x + 1 ,y - 1)
                 ,(x - 1, y    )
                 ,(x + 1 ,y    )
                 ,(x - 1, y + 1)
                 ,(x     ,y + 1)
                 ,(x + 1 ,y + 1)]

takenSeatVisible :: Board -> (Int, Int) -> (Int, Int) -> Bool
takenSeatVisible b (x, y) (dx, dy) =
  case seat of Nothing       -> False
               Just Empty    -> False
               Just Occupied -> True
               Just Floor    -> takenSeatVisible b (x + dx, y + dy) (dx, dy)
  where
    seat = safeGet2 (x + dx, y + dy) b

takenSeatsVisible :: Board -> (Int, Int) -> Int
takenSeatsVisible b (x, y) = length (filter id takenDirections)
  where
    takenDirections = map (takenSeatVisible b (x, y)) directions
    directions = [(-1, -1)
                 ,( 0, -1)
                 ,( 1, -1)
                 ,(-1,  0)
                 ,( 1,  0)
                 ,(-1,  1)
                 ,( 0,  1)
                 ,( 1,  1)]

nextSeat1 :: Board -> (Int, Int) -> Seat
nextSeat1 b (x, y) =
  case currentSeat of Just Floor ->    Floor
                      Just Empty ->    if taken == 0
                                       then Occupied
                                       else Empty
                      Just Occupied -> if taken >= 4
                                       then Empty
                                       else Occupied

  where
    taken = takenNeighbors x y b
    currentSeat = safeGet2 (x, y) b

nextSeat2 :: Board -> (Int, Int) -> Seat
nextSeat2 b (x, y) =
  case currentSeat of Just Floor ->    Floor
                      Just Empty ->    if taken == 0
                                       then Occupied
                                       else Empty
                      Just Occupied -> if taken >= 5
                                       then Empty
                                       else Occupied

  where
    taken = takenSeatsVisible b (x, y)
    currentSeat = safeGet2 (x, y) b


nextBoard :: ((Int, Int) -> Seat) -> Board -> Board
nextBoard nextSeat b =
    [[ nextSeat (i, j) | j <- [0..h-1] ] | i <- [0..w-1]]
  where
    w = width b
    h = height b

boards1 :: Board -> [Board]
boards1 b = b:(boards1 $ nextBoard (nextSeat1 b) b)

boards2 :: Board -> [Board]
boards2 b = b:(boards2 $ nextBoard (nextSeat2 b) b)

getUntilEqual :: Eq a => [a] -> a
getUntilEqual (x1:x2:xs) = if x1 == x2
                           then x1
                           else getUntilEqual (x2:xs)

countTaken :: Board -> Int
countTaken = length . filter (==Occupied) . foldr1 (++)

solution1 :: Board -> Int
solution1 b = countTaken finalBoard
  where
    finalBoard = getUntilEqual $ boards1 b

solution2 :: Board -> Int
solution2 b = countTaken finalBoard
  where
    finalBoard = getUntilEqual $ boards2 b

main = do
  handle <- openFile filename ReadMode
  contents <- hGetContents handle

  putStr "Task 1 result is: "
  putStr $ show (solution1 $ toBoard $ lines contents) ++ "\n"
  putStr "Task 2 result is: "
  putStr $ show (solution2 $ toBoard $ lines contents) ++ "\n"

  hClose handle


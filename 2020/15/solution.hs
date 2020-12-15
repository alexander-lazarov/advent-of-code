import qualified Data.Map.Strict as Map

data State = State { history :: Map.Map Int Int, currentTurn :: Int, currentNum :: Int} deriving Show

input :: [Int]
input = [0, 1, 5, 10, 3, 12, 19]

initialMap :: [Int] -> Map.Map Int Int
initialMap x = Map.fromList $ zip x [0..]

initialState :: [Int] -> State
initialState x = State {history = (initialMap x), currentTurn = 0, currentNum = 0}

nextState :: State -> State
nextState s =
    if currentTurn s < l
    then State {history = history s, currentTurn = nextTurn, currentNum = currentNum s}
    else State {history = nextHistory, currentTurn = nextTurn, currentNum = nextNum }
  where
    nextTurn = (currentTurn s) + 1
    currentNumHistory = Map.lookup (currentNum s) (history s)
    nextNum = case currentNumHistory of Nothing -> 0
                                        Just n  -> (currentTurn s) - n
    nextHistory = Map.insert (currentNum s) (currentTurn s) (history s)
    l = Map.size $ history s


nthNumber :: State -> Int -> State
nthNumber s 0 = s
nthNumber s n = (nthNumber $! (nextState s)) $! (n - 1)

main = do
  putStr "Part 1 answer is: "
  putStr $ show $ currentNum $ nthNumber s (2020 - 1)
  putStr "\n"

  putStr "Part 2 answer is: "
  putStr $ show $ currentNum $ nthNumber s (30000000 - 1)
  putStr "\n"

  where
    s = initialState $! input

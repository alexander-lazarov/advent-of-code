import System.IO
import Text.Parsec
import Text.Parsec.String

filename = "input.txt"
-- filename = "input-sample.txt"

data Position = Position {
   x :: Int,
   y :: Int,
   aim :: Int
} deriving Show

data Direction = Fwd | Down | Up deriving Show

data Command = Command {
   d :: Direction,
   magnitude :: Int
} deriving Show

parseCommands :: Parser [Command]
parseCommands = many1 parseCommand

parseCommand :: Parser Command
parseCommand = do
  d <- parseDirection
  char ' '
  m <- parseMagnitude
  char '\n'
  return $ Command d m

parseUp :: Parser Direction
parseUp = do
  string "up"
  return Up

parseDown :: Parser Direction
parseDown = do
  string "down"
  return Down

parseFwd :: Parser Direction
parseFwd = do
  string "forward"
  return Fwd

parseDirection :: Parser Direction
parseDirection = parseUp <|> parseDown <|> parseFwd

parseMagnitude :: Parser Int
parseMagnitude = do
  m <- many1 digit
  return $ read m

parseInput :: String -> [Command]
parseInput s = let
  parsed = parse parseCommands "" s
  in
  case parsed of Left e  -> []
                 Right p -> p

initialPosition :: Position
initialPosition = Position 0 0 0

nextTurn1 :: Position -> Command -> Position
nextTurn1 Position {x=x, y=y, aim=aim} Command {d=Up, magnitude=magnitude} =
  Position { x = x, y = y - magnitude, aim = aim }
nextTurn1 Position {x=x, y=y, aim=aim} Command {d=Down, magnitude=magnitude} =
  Position { x = x, y = y + magnitude, aim = aim }
nextTurn1 Position {x=x, y=y, aim=aim} Command {d=Fwd, magnitude=magnitude} =
  Position { x = x + magnitude, y = y, aim = aim }

allTurns1 :: [Command] -> Position
allTurns1 commands = foldl nextTurn1 initialPosition commands

solution_1 :: [Command] -> Int
solution_1 = positionToResult . allTurns1

solution_2 :: [Command] -> Int
solution_2 = positionToResult . allTurns2

nextTurn2 :: Position -> Command -> Position
nextTurn2 Position {x=x, y=y, aim=aim} Command {d=Up, magnitude = magnitude} =
  Position { x = x, y = y, aim = aim - magnitude }
nextTurn2 Position {x=x, y=y, aim=aim} Command {d=Down, magnitude = magnitude} =
  Position { x = x, y = y, aim = aim + magnitude }
nextTurn2 Position {x=x, y=y, aim=aim} Command {d=Fwd, magnitude = magnitude} =
  Position { x = x + magnitude, y = y + magnitude * aim, aim = aim }

allTurns2 :: [Command] -> Position
allTurns2 commands = foldl nextTurn2 initialPosition commands

positionToResult :: Position -> Int
positionToResult Position { x = x, y = y } = x * y

main = do
  handle <- openFile filename ReadMode
  contents <- hGetContents handle

  putStr "Task 1 result is: "
  putStr $ (show $ solution_1 $ parseInput contents) ++ "\n"
  putStr "Task 2 result is: "
  putStr $ (show $ solution_2 $ parseInput contents) ++ "\n"

  hClose handle

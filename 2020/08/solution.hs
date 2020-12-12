import System.IO
import Text.Parsec
import Text.Parsec.String

data OpCode = JMP | NOP | ACC
data MachineStatus = Running | InLoop | Terminated deriving Eq
data Instruction = Instruction { opcode :: OpCode, offset :: Int }
data Execution = Execution {
  pc :: Int,
  acc :: Int,
  usedInstructions :: [Int],
  status :: MachineStatus
}

filename = "input.txt"

parseJmp :: Parser OpCode
parseJmp = do
  string "jmp"
  return JMP

parseNop :: Parser OpCode
parseNop = do
  string "nop"
  return NOP

parseAcc :: Parser OpCode
parseAcc = do
  string "acc"
  return ACC

parseOpcode :: Parser OpCode
parseOpcode = parseJmp <|> parseNop <|> parseAcc

signedDigit :: Parser Int
signedDigit = do
    sign <- char '-' <|> char '+'
    num <- many1 digit
    return $ (factor sign) * (read num)
  where
    factor sign = if sign == '-'
                  then -1
                  else 1

parseInstruction :: Parser Instruction
parseInstruction = do
  opCode <- parseOpcode
  char ' '
  offset <- signedDigit
  char '\n'
  return $ Instruction opCode offset

parseProgram :: Parser [Instruction]
parseProgram = many1 parseInstruction

parseInput :: String -> [Instruction]
parseInput s = let
  parsed = parse parseProgram "" s
  in
  case parsed of Left e  -> []
                 Right p -> p

executeStep :: [Instruction] -> Execution -> Execution
executeStep program Execution { pc = pc, acc = acc, usedInstructions = usedInstructions, status = status }
    | terminated = Execution pc acc usedInstructions Terminated
    | looped     = Execution pc acc usedInstructions InLoop
    | otherwise  = Execution nextPc nextAcc (pc:usedInstructions) Running
  where
    Instruction {opcode=opcode, offset=offset} = program !! pc
    looped = any (==pc) usedInstructions
    terminated = pc >= length program
    nextPc = case opcode of NOP -> pc + 1
                            ACC -> pc + 1
                            JMP -> pc + offset

    nextAcc = case opcode of NOP -> acc
                             ACC -> acc + offset
                             JMP -> acc


startState :: Execution
startState = Execution 0 0 [] Running

executeProgram :: [Instruction] -> Execution -> Execution
executeProgram p e = case status e of InLoop     -> e
                                      Terminated -> e
                                      Running    -> executeProgram p $ executeStep p e

solution1 :: [Instruction] -> Int
solution1 program = acc $ executeProgram program startState

mutateInstruction :: Instruction -> Instruction
mutateInstruction i = case opcode i of ACC -> i
                                       JMP -> Instruction NOP $ offset i
                                       NOP -> Instruction JMP $ offset i

mutateProgram :: [Instruction] -> Int -> [Instruction]
mutateProgram p i =
    beginning ++ [mutated] ++ end
  where
    beginning = take i p
    end = drop (i + 1) p
    mutated = mutateInstruction $ p !! i

solution2 p =
    acc $ executeProgram terminatedProgram startState
  where
    terminatedProgram = head terminatingPrograms
    mutatedPrograms = map (mutateProgram p) [0..l]
    terminatingPrograms = filter terminates mutatedPrograms
    l = length p
    terminates p = status (executeProgram p startState) == Terminated

main = do
  handle <- openFile filename ReadMode
  contents <- hGetContents handle

  putStr "Task 1 result is: "
  putStr $ (show $ solution1 $ parseInput contents) ++ "\n"
  putStr "Task 2 result is: "
  putStr $ (show $ solution2 $ parseInput contents) ++ "\n"

  hClose handle


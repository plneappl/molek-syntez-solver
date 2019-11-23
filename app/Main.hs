module Main where
import Board
import Card
import Solver

exampleBoard :: Board
exampleBoard = map (map fromChar) ["K088D6", "8T6907", "D8TV6K", "09DTKV", "D7990V", "VT776K"]

main :: IO ()
main = do
  board <- getBoardFromIo
  --let board = exampleBoard
  print board
  putStrLn "========="
  let state = mkSolveState board
  let states = solve board
  print $ take 1 states
  --sequence_ $ map (print . getBoard) states

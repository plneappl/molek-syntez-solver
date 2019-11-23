module Main where
import Data.Maybe
import System.Random
import Board
import Card
import Solver

exampleBoard :: Board
exampleBoard = map (map fromChar) ["K088D6", "8T6907", "D8TV6K", "09DTKV", "D7990V", "VT776K"]

printSolution :: Maybe SolveState -> IO ()
printSolution Nothing = print "No solution found (without cheating)"
printSolution (Just (SolveState _ moves)) = sequence_ $ map printMove moves where
  printMove (Move from to) = putStrLn $ "Move " ++ (show $ from + 1) ++ " to " ++ (show $ to + 1)

main :: IO () 
main = do
  board <- getBoardFromIo
  stdGen <- getStdGen
  --let board = exampleBoard
  print board
  putStrLn "========="
  let state = mkSolveState board
  let states = solve stdGen board
  printSolution $ listToMaybe states
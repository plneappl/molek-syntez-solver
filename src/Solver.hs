module Solver where
import Board
import Debug.Trace

data SolveState = SolveState {getBoard :: Board, getMoves :: Moves} deriving (Show)

mkSolveState :: Board -> SolveState
mkSolveState b = SolveState b []

solve :: Board -> [SolveState]
solve b = filter (boardWins . getBoard) $ repeater $ mkSolveState b where
  repeater state = let 
    nextStates = tryColumns state in
    state `seq` 
    if null nextStates then [state] else concatMap repeater nextStates

tryColumns :: SolveState -> [SolveState]
tryColumns s = concatMap (tryColumn s) [0..5]

tryColumn :: SolveState -> Int -> [SolveState]
tryColumn (SolveState b ms) i = map (\m -> SolveState (doMove b m) (ms ++ [m])) $ validMovesForColumn b i

boardWins :: Board -> Bool
boardWins b = and $ map columnIsFine $ zip [0..] b where
  columnIsFine (idx, col) = let
    movingCards = movablePart b idx in
    length col == length movingCards
module Solver where
import Board
import System.Random
import Data.Vector(Vector, fromList, toList)
import VectorShuffling.Immutable

data SolveState = SolveState {getBoard :: Board, getMoves :: Moves} deriving (Show)

mkSolveState :: Board -> SolveState
mkSolveState b = SolveState b []

solve :: StdGen -> Board -> [SolveState]
solve stdGen b = filter (boardWins . getBoard) $ snd $ repeater stdGen $ mkSolveState b where
  columnIdxs :: Vector Int
  columnIdxs = fromList [0..5]
  repeater :: StdGen -> SolveState -> (StdGen, [SolveState])
  repeater r state = let 
    (order, r') = shuffle columnIdxs r
    nextStates = tryColumns state (toList order) in
    state `seq` 
    if null nextStates 
      then (r, [state]) 
      else foldr (\s (r0, ss) -> 
        let (r1, ss') = repeater r0 s in
        (r1, ss ++ ss')) (r', []) nextStates


tryColumns :: SolveState -> [Int] -> [SolveState]
tryColumns s order = concatMap (tryColumn s) order

tryColumn :: SolveState -> Int -> [SolveState]
tryColumn (SolveState b ms) i = map (\m -> SolveState (doMove b m) (ms ++ [m])) $ validMovesForColumn b i

boardWins :: Board -> Bool
boardWins b = and $ map columnIsFine $ zip [0..] b where
  columnIsFine (idx, col) = let
    movingCards = movablePart b idx in
    length col == length movingCards
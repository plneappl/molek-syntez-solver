module Board where
import Card
import Lib
import Data.List.Extra

type Board = [[Card]]

getBoardFromIo :: IO (Board)
getBoardFromIo = do
  columns <- sequence $ take 6 $ repeat getLine
  return $ map ((map fromChar) . upper) columns

data Move = Move Int Int deriving (Eq, Ord, Show)
type Moves = [Move]

doMove :: Board -> Move -> Board
doMove b (Move from to) = let
  fromColumn = b !! from
  movingCards = movablePart b from
  remainingCards = take (length fromColumn - length movingCards) fromColumn in
  modifyAt (modifyAt b from (const remainingCards)) to (++ movingCards)

movablePart :: Board -> Int -> [Card]
movablePart b colIdx = movablePart' $ reverse $ b !! colIdx where
  movablePart' [] = []
  movablePart' column@(firstCard:otherCards) = let
    otherCards' = zip column $ otherCards 
    movableColumn = firstCard : (map snd $ takeWhile (\(c1, c2) -> c1 /= Ace && succ c1 == c2) otherCards') in
    reverse movableColumn

placeableColumns :: Board -> Card -> [Int]
placeableColumns b card = map snd $ filter (isPlaceable . fst) (zip b [0..]) where
  isPlaceable [] = True
  isPlaceable column = card /= Ace && succ card == last column

validMovesForColumn :: Board -> Int -> [Move]
validMovesForColumn b idx = filter (idiotMove b) $ if null $ b !! idx then [] else let
  (firstCard:_) = movablePart b idx in
  map (Move idx) $ placeableColumns b firstCard

idiotMove :: Board -> Move -> Bool
idiotMove b (Move from to) = let
  movingCards = movablePart b from
  movingCardsIsWholeColumn = length movingCards == length (b !! from)
  targetIsEmpty = null $ b !! to in
  not $ movingCardsIsWholeColumn && targetIsEmpty

module Lib where

modifyAt :: [a] -> Int -> (a -> a) -> [a]
modifyAt as idx f = take idx as ++ [f $ as !! idx] ++ drop (idx + 1) as
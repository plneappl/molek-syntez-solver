module Card where
import Debug.Trace

data Card = Six | Seven | Eight | Nine | Ten | Jack | Queen | King | Ace deriving (Eq, Ord, Show, Enum)

fromChar :: Char -> Card
fromChar '6' = Six
fromChar '7' = Seven
fromChar '8' = Eight
fromChar '9' = Nine
fromChar '0' = Ten
fromChar 'V' = Jack
fromChar 'Q' = Queen
fromChar 'D' = Queen
fromChar 'K' = King
fromChar 'T' = Ace
fromChar 'A' = Ace

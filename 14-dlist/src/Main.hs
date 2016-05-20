module Main where

import qualified Data.DList as D
import Data.Monoid

testi = D.toList $ D.append (D.fromList [1..5]) (D.fromList [1..10])

--listojen concatenointi voidaan siis käsitellä funktiona, jolloin mitään listaa ei siis varsinaisesti vielä rakenneta.
foo :: Num a => [a] -> [a]
foo = ([1, 2] <>) . ([3, 4] <>)

-- DList voidaan siis määritellä ihan vain tyyppialiaksella funktiolle:
type MyDList a = [a] -> [a]
(+++) = (.)
toList = ($[])
dl = (<>)

oma_testi = toList $ dl [1..5] +++ dl [1..10]

-- dlist-paketin toteutus on newtype, ehkä siksi että sille saa kasan hyödyllisiä tyyppiluokkainstansseja.

main = do
  print testi
  print $ foo []
  print oma_testi

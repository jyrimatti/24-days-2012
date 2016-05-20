{-# LANGUAGE TemplateHaskell #-}
module Main where

import Control.Lens
import GHC.Natural

-- kentät nimetty hassusti koska makroilla tehdään varsinaiset kentät
data Point = Point { _x, _y :: Double } deriving (Show)

data Monster = Monster { _monsterLocation :: Point } deriving (Show)

-- ja tässä ne makrot. Näistä olisi kiva päästä eroon...
--makeLenses ''Monster
--makeLenses ''Point
-- Käsin kirjoitettuna jotenkin näin:
monsterLocation f (Monster a) = Monster <$> f a
x f (Point a b) = (\a' -> Point a' b) <$> f a
y f (Point a b) = (\b' -> Point a  b') <$> f b

ogre = Monster (Point 0 0)

-- Tämä muuten kuin esimerkki, mut jätin objektin pois jotta tämä on enemmän kuin operaatio
move = monsterLocation.x +~ 1

-- Mua hämää nuo kaikki operaattorit, mieluummin sanoisin yleisesti:
move2 = over (monsterLocation.x) (+ 1)
reset = set (monsterLocation.x) 0

nat :: Prism' Integer Natural
nat = prism toInteger $ \ i ->
   if i < 0
   then Left i
   else Right (fromInteger i)

main = do
  print $ ogre
  print $ move ogre
  print $ move2 ogre
  print $ reset ogre
  print $ 5 ^? nat
  print $ (-5) ^? nat
  print $ both.nat *~ 2 $ (-3,4)
  print $ both.nat *~ 2 $ (8,4)

{-# LANGUAGE ScopedTypeVariables #-}
module Main where

import System.Random
import Data.Foldable
import qualified Data.Set as Set
import qualified Data.Map as Map
import qualified Data.Tree as Tree

-- Ei muista koskaan operaattoreita, niin sovitaan että
-- $$ on ikäänkuin $ eli applikaatio, mutta funktio arvo monadisia.
infixr 0 $$
($$) :: Monad m => (a -> m b) -> m a -> m b
($$) = (=<<)

rnd :: Int -> IO Int
rnd n = getStdRandom (randomR (0,n));

type Person = String
data Colour = Red | Green | Blue deriving (Show, Eq, Ord)
peopleFavColours :: IO (Map.Map Person (Set.Set Colour))
peopleFavColours = return $ Map.fromList [("Tupu", Set.fromList [Red,Green]),
                                          ("Hupu", Set.fromList [Red,Blue]), 
                                          ("Lupu", Set.fromList [Green])]

allFavColours :: IO (Set.Set Colour)
allFavColours = fold <$> peopleFavColours

-- luodaan random Rose-Tree
makeTree :: IO (Tree.Tree String)
makeTree = Tree.unfoldTreeM (\b -> makeNode b <$> rnd b) $$ rnd 9
  where makeNode value childCount = (show value, tail [0..childCount])

main = do
  putStrLn $$ Map.showTree <$> peopleFavColours
  putStrLn $$ show <$> allFavColours
  putStrLn ""

  puu <- makeTree
  putStrLn $ Tree.drawTree puu
  putStrLn $ fold puu



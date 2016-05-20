module Main where

import Control.Concurrent (forkIO)
import Control.Concurrent.Chan
import Control.Monad (forever)
import Data.Monoid (Sum(..),Product(..))
import System.Environment (lookupEnv)

echo :: Chan String -> IO ()
echo c = forever $ readChan c >>= putStrLn

main :: IO ()
main = do
  c <- newChan
  forkIO (echo c)
  forever $ getLine >>= writeChan c

stats :: [Int] -> (Sum Int, Product Int)
stats = mconcat . map (\x -> (Sum x, Product x))

foo = lookupEnv "HOME" >>= traverse putStrLn

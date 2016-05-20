module Main where

import Pipes
import Pipes.Core
import Control.Monad.Trans.Writer.Lazy
import Data.Monoid

name :: Producer String IO ()
name = do
  lift $ putStr "Ho ho ho! What is your name? "
  lift getLine >>= respond

data Present = Present String
  deriving (Show)

presents :: Producer Present IO String
presents = do
    lift (putStrLn "And what presents would you like?") >> go
  where
    go = lift getLine >-> takeWhile (not . null) >-> map Present

main = do
  runEffect $ name
  runEffect $ name >-> print
  runEffect $ presents >-> print

  --First (Just name) <- execWriterT $ runEffect $ raise name >-> head
  --presents <- execWriterT $ runEffect $ raise presents >-> toListT
  --putStrLn (name ++ " wants: " ++ show presents)

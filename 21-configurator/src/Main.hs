{-# LANGUAGE OverloadedStrings, ScopedTypeVariables #-}
module Main where

import Control.Monad
import Control.Concurrent
import qualified Data.Configurator as DC

main = forever $ do
  (config,_) <- DC.autoReload DC.autoConfig [ DC.Required "app.cfg" ]
  Just (hello :: String)  <- DC.lookup config "viestit.hello"
  Just (arvo :: Int) <- DC.lookup config "viestit.arvo"
  print $ hello ++ " arvolla " ++ show arvo ++ "!" 
  threadDelay $ 1000*1000

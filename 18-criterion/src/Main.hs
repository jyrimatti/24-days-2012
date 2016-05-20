module Main where

import Criterion
import Criterion.Main
import Criterion.Types

fact :: Integer -> Integer
fact 1 = 1
fact n = n * fact (pred n)

main :: IO ()
main = defaultMainWith
    defaultConfig { resamples = 1000 }
    [ bench "fact 30" $ nf fact 30
    , bench "fact 40" $ nf fact 40
    ]

module Main where

import Data.Char

foo = [(10 + 20), 9] == (map (\x -> x * 3) [69, 3])

main = getLine >>= return . map toUpper

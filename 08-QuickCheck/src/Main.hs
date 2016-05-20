{-# LANGUAGE FlexibleInstances #-}
module Main where

import Test.QuickCheck

absAverage1 :: [Double] -> Double
absAverage1 ds = sum ds / fromIntegral (length ds)

quickCheck1 :: IO ()
quickCheck1 = quickCheck $ \x -> absAverage1 x >= 0

quickCheck2 :: IO ()
quickCheck2 = quickCheck $ \x -> length x > 1 ==> absAverage1 x >= 0

absAverage2 :: [Double] -> Double
absAverage2 ds = sum (map abs ds) / fromIntegral (length ds)

quickCheck3 :: IO ()
quickCheck3 = quickCheck $ \x -> length x > 1 ==> absAverage2 x >= 0

-- QuickCheck:n kauneus tulee paremmin esiin kun tehdään omia arbitraryja.
-- Tässä tapauksessa haluttiin testata non-empty-double-listillä joten tehdään sellainen:
instance Arbitrary [Double] where
  arbitrary = do
    NonEmpty xs <- arbitrary
    return xs
-- NonEmpty löytyy paketista Test.QuickCheck.Modifiers

-- Nyt voi itse testissä olettaa että input on mitä halutaankin.
quickCheck4 :: IO ()
quickCheck4 = quickCheck $ \x -> absAverage2 x >= 0
-- Joskus (ehkä tässäkin casessa) on tosin fiksumpi tehdä testiä rajoittamalla, mutta esim näin:
quickCheck5 = quickCheck $ \(NonEmpty xs) -> absAverage2 xs >= 0

-- Testistä tulee luettavampi kun se vielä nimetään järkevästi
-- ja jätetään varsinainen suoritus kutsupuolelle, eli siis paras olisi jompikumpi seuraavista riippuen siitä haluaako tähän arbitraryn vai ei:
absAverage2_returnsAlwaysNonNegative6 xs = absAverage2 xs >= 0
absAverage2_returnsAlwaysNonNegative7 (NonEmpty xs) = absAverage2 xs >= 0

main = do
  putStrLn "1"
  quickCheck1
  putStrLn ""

  putStrLn "2"
  quickCheck2
  putStrLn ""

  putStrLn "3"
  quickCheck3
  putStrLn ""

  putStrLn "4"
  quickCheck4
  putStrLn ""

  putStrLn "5"
  quickCheck5
  putStrLn ""

  putStrLn "6"
  quickCheck absAverage2_returnsAlwaysNonNegative6
  putStrLn ""

  putStrLn "7"
  quickCheck absAverage2_returnsAlwaysNonNegative7

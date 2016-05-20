module Main where

import Text.Parsec
import Data.Char

-- muutettu härskisti niin, että vaikka parseri matchaa upper-case-merkkeihin kuten ennenkin,
-- niin se palauttaakin parsitun tuloksen lowercasena
countryCode = count 2 upper >>= return . map toLower

regCode = count 3 (upper <|> digit)

-- muutettu niin, että vaikka parser matchaa kuten ennenkin,
-- niin se palauttaa aina luvun "42" parsitun arvon sijaan
regYear = count 2 digit >> return "42"

-- muutettu törkeästi niin että vaikka parser matchaa kuten ennenkin,
-- se palauttaa parsitun arvon sijaan sarakenumeron jossa ollaan syötteessä menossa.
recordingId = count 5 digit >> show . sourceColumn <$> getPosition

data ISRC = ISRC { isrcCountryCode :: String
                 , isrcRegCode :: String
                 , isrcRegYear :: Int
                 , isrcRecording :: Int
                 } deriving (Show)

isrcParser = ISRC <$> countryCode
                  <*> regCode
                  <*> fmap read regYear
                  <*> fmap read recordingId
                  <*  eof

isrcParser2 = mconcat <$> sequence [ countryCode, regCode, regYear, recordingId ] <* eof

main = do
   print $ parse isrcParser "" "USPR37300012"
   print $ parse isrcParser2 "" "USPR37300012"

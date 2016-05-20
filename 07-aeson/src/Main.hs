{-# LANGUAGE OverloadedStrings, ScopedTypeVariables, DeriveGeneric  #-}
module Main where

import System.Environment
import GHC.Generics
import Data.Aeson

-- Erilaiset stringit on vielä melkonen sotku (String,Text,ByteString...Strict/Lazy...)
import Prelude hiding (putStrLn)
import Data.Text.Lazy (pack)
import Data.Text.Lazy.IO (putStrLn)
import Data.Text.Lazy.Encoding (encodeUtf8,decodeUtf8)

data Cheese = Cheese { maturity :: Maturity
                     , weight :: Double
                     } deriving Generic

data Maturity = Strong | Mild deriving Generic

-- Näitä ei tarvita jos generoitu kelpaa.
--
--instance ToJSON Maturity where
--  toJSON Strong = String "Strong"
--  toJSON Mild   = String "Mild"
--
--instance FromJSON Maturity where
--  parseJSON (String "Strong") = pure Strong
--  parseJSON (String "Mild")   = pure Mild
--  parseJSON _                 = fail "Unknown cheese strength!"
--
--instance ToJSON Cheese where
--  toJSON (Cheese cheeseMaturity cheeseWeight) =
--     object [ "maturity" .= maturity
--            , "weight" .= weight
--            ]
--
--instance FromJSON Cheese where
--  parseJSON (Object o) = Cheese <$> o .: "maturity"
--                                <*> o .: "weight"
--  parseJSON _ = fail "Failed to parse cheese!"

-- derive Generic ja LANGUAGE DeriveGeneric niin kääntäjä arpoo instanssit.
-- Tarvii vain nämä tyhjät julistukset:
instance ToJSON Maturity
instance FromJSON Maturity
instance ToJSON Cheese
instance FromJSON Cheese

main = do
  [arg] <- getArgs
  let cheese = eitherDecode $ encodeUtf8 $ pack arg
  putStrLn $ case cheese of
    Left err -> pack err
    Right (c :: [Cheese]) -> decodeUtf8 $ encode c


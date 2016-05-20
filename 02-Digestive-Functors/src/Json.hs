{-# LANGUAGE DeriveGeneric, OverloadedStrings #-}
module Main where

import Form
import System.Environment
import qualified Data.ByteString.Lazy.Char8 as BS
import Data.Aeson (json,FromJSON)
import Data.Attoparsec.Lazy (parse, maybeResult, eitherResult)
import Text.Digestive.Aeson
import Text.Digestive.View
import Data.Text (Text)
import Data.String (IsString)

-- DeriveGeneric:n kanssa nämä hoitavat oletusinstanssit json:sta lukemiseen. Riittää meille.
instance FromJSON Department
instance FromJSON Employee

-- Tästä en enää tiedä mitä tässä tapahtuu :)
-- parsitaan json "käsin" ja ajetaan validoinnin läpi.
postJson :: (Monad m1) => m1 BS.ByteString -> m1 (View Text, Maybe Employee)
postJson str = do
  Just parsedJson <- maybeResult . parse json <$> str
  digestJSON myform parsedJson

-- Syöte json-stringinä ainoana parametrina.
-- Tulostetaan virheet tai onnistunut parsinta.
main = do
  [input] <- getArgs
  (v,a) <- postJson $ return $ BS.pack input
  case a of
    Nothing -> print $ jsonErrors v
    Just v -> print v


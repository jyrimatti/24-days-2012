{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified Data.Text as T
import qualified Data.Text.Lazy as TL
import qualified Data.Text.Encoding as TE
import qualified Data.Text.Lazy.Encoding as TLE
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as BL
import qualified Data.Text.ICU as I

-- tämä toimii vain jos OverloadedStrings -lisäosa on käytössä
literal2text :: T.Text
literal2text = "literaali josta halutaa Text"

-- tämä toimii aina. 'pack' ja 'unpack' ovat yleensäkin funktiot jotka muuntavat ainakin merkkijonoja (String,ByteString,Text,...) muodosta toiseen.
string2text :: String -> T.Text
string2text = T.pack

text2string :: T.Text -> String
text2string = T.unpack

-- ByteString on vain tavujono, joten näissä pitää olla explisiittinen missä muodossa teksti tavujonossa on!
-- Jos muidenkin kielten kirjastoissa oltaisiin näin explisiittisiä niin monelta bugilta olisi vältytty.
bytestring2text :: B.ByteString -> T.Text
bytestring2text = TE.decodeUtf8

text2bytestring :: T.Text -> B.ByteString
text2bytestring = TE.encodeUtf8

lazybytestring2lazytext :: BL.ByteString -> TL.Text
lazybytestring2lazytext = TLE.decodeUtf8

lazytext2lazybytestring :: TL.Text -> BL.ByteString
lazytext2lazybytestring = TLE.encodeUtf8

-- Jos on käsitellyt Unicodea niin lienee törmännyt ICU-kirjastoon.
-- text-icu on haskell-bindingit tuohon kirjastoon, josta löytyy unicode käsittelyä ja regexiä jne

-- Jos OverloadedString-laajennus käytössä, voi regexin kirjoittaa suoraan stringinä
regex :: I.Regex
regex = "[A-Z]\\p{Letter}{4}\\s\\w{5}"

-- Muuten sitten näin, jolloin voi antaa parametrejakin
regex2 :: I.Regex
regex2 = I.regex [I.CaseInsensitive] "[a-z]\\p{Letter}{4}\\s\\w{5}"

main = do
  print $ I.find regex "Hello world"
  print $ I.find regex2 "Hello world"

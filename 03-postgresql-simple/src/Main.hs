{-# LANGUAGE OverloadedStrings #-}
module Main where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.ToField
import Data.Text (Text,pack)
import Control.Monad
import System.Environment

data Present = Present { presentName :: Text } deriving Show

data Location = Location { locLat :: Double
                         , locLong :: Double
                         } deriving Show

data Child = Child { childName :: Text
                   , childLocation :: Location
                   } deriving Show

-- Muuttaa 'rivin' Presentiksi
instance FromRow Present where
  fromRow = Present <$> field

instance FromRow Child where
  fromRow = Child <$> field <*> liftM2 Location field field

-- Muuttaa Presentin 'arvoksi' (koska sattuu koostumaan yhdestä arvosta)
instance ToField Present where
  toField (Present n) = toField n

-- underscore perässä tarkoittaa versiota funktiosta, jolle ei anneta kantaan meneviä parametreja
allChildren :: Connection -> IO [Child]
allChildren c = query_ c "SELECT childName, locLat, locLong FROM child"

allPresents :: Connection -> IO [Present]
allPresents c = query_ c "SELECT presentName FROM present"

aChildren :: Connection -> IO [Child]
aChildren c = query c "SELECT childName, locLat, locLong FROM child WHERE childName LIKE ?" (["a%"] :: [String])

main = do
  args <- getArgs
  conn <- connectPostgreSQL ""
  execute_ conn "create table if not exists Present (presentName varchar(20))"
  execute_ conn "create table if not exists Child (childName varchar(20), locLat double precision, locLong double precision)"

  case args of
   [] -> do
     -- voidaan ladata "imperatiivisesti" väliarvoihin...
     cs <- allChildren conn
     cs2 <- aChildren conn
     -- ...tai kikkailla monadisesti "antamalla monadinen arvo a->mb funktiolle sisään" ;)
     (\a -> print $ "All presents: " ++ show a) =<< allPresents conn
     print $ "All children: " ++ show cs
     print $ "Children whose name starts with 'a': " ++ show cs2
   ["present", name] -> do
     -- 1-parametrisen datatyypin voi insertoida tyypitetysti
     execute conn "insert into present values (?)" [Present $ pack name]
     print "Added present."
   ["child", name, lat, long] -> do
     -- Ilmeisesti tämä ei ole "niin ORM" että voisi insertoida yleisesti datatyypin
     execute conn "insert into child values (?,?,?)" [name, lat, long]
     print "Added child."
   ["clear"] -> do
     execute_ conn "drop table present"
     execute_ conn "drop table child"
     print "Database cleared."
   _ -> print "Wrong syntax!"

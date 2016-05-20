{-# LANGUAGE OverloadedStrings #-}
module Main where

import Database.PostgreSQL.Simple
import Control.Monad.Trans.Class
import Control.Monad.Trans.Reader
import Control.Monad.Trans.Writer
import Data.Maybe

type User = String



-- Explisiittisellä Connection-välityksellä:

listAllUsers1 :: Connection -> IO [User]
listAllUsers1 c = query c "SELECT * FROM users" ()

findUser1 :: Connection -> User -> IO (Maybe User)
findUser1 c name = listToMaybe <$>
  query c "SELECT * FROM users WHERE name = ?" (Only name)

listAllUsers :: ReaderT Connection IO [User]
listAllUsers = query' "SELECT * FROM users" ()



-- Reader-monadia käyttäen (eli käytännössä ReaderT-transformer koska monad-stack)):

findUser :: User -> ReaderT Connection IO (Maybe User)
findUser name = listToMaybe <$>
  query' "SELECT * FROM users WHERE name = ?" (Only name)

listAllUsersLogged :: WriterT [String] (ReaderT Connection IO) [User]
listAllUsersLogged = do
  tell ["Listing all users..."]
  users <- lift listAllUsers
  tell ["Found " ++ show (length users) ++ " users"]
  return users

query' :: (FromRow a, ToRow q) => Query -> q -> ReaderT Connection IO [a]
query' sql params = do
  c <- ask
  lift $ query c sql params



main = do
  c <- connectPostgreSQL ""
  
  -- explisiittisellä connection-välityksellä:
  users <- listAllUsers1 c
  user <- findUser1 c "Bob"

  -- reader-monadilla:
  flip runReaderT c $ do
    users <- listAllUsers
    user <- findUser "Bob"
    return ()


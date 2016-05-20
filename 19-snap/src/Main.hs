{-# LANGUAGE TemplateHaskell, OverloadedStrings #-}
module Main where

import Snap
import Snap.Snaplet.PostgresqlSimple
import Control.Lens
import Data.Maybe (listToMaybe)
import Data.Monoid ((<>))
import Data.Text (pack)

data App = App { _db :: Snaplet Postgres }

makeLenses ''App

initApp :: SnapletInit App App
initApp = makeSnaplet "myapp" "My application" Nothing $
  App <$> nestSnaplet "db" db pgsInit
      <* addRoutes [("/hello/:id", helloDb)]

helloDb :: Handler App App ()
helloDb = do
  Just mUId <- getParam "id"
  userName <- with db $
    listToMaybe <$>
      query "SELECT name FROM users WHERE id = ?" (Only mUId)
  writeText $ maybe "User not found" (\s -> "Hello, " <> pack s) userName

main :: IO ()
main = serveSnaplet defaultConfig initApp

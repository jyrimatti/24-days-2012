{-# LANGUAGE OverloadedStrings, TemplateHaskell #-}
module Main where

import Form
import Html

import Control.Lens.TH
import Control.Exception (SomeException, try)
import Snap.Http.Server (defaultConfig, httpServe)
import Snap.Snaplet
import Snap.Blaze
import Text.Blaze.Html
import qualified Text.Blaze.Html5 as H
import Data.ByteString (ByteString)
import Text.Digestive
import Text.Digestive.Snap
import System.IO (hPutStrLn, stderr)
import qualified Data.Text as T

data App = App

makeLenses ''App

type AppHandler = Handler App App

routes :: [(ByteString, Handler App App ())]
routes = [("/", handler)]

handler :: Handler App App ()
handler = do
  (view, result) <- runForm "employee" myform
  case result of
    Nothing -> blaze $ renderForm view
    Just f -> blaze $ H.p "moi"

app :: SnapletInit App App
app = makeSnaplet "app" "esimerkki" Nothing $ do
    addRoutes routes
    return App

main :: IO ()
main = do
    (msgs, site, cleanup) <- runSnaplet Nothing app
    hPutStrLn stderr $ T.unpack msgs
    _ <- try $ httpServe defaultConfig site :: IO (Either SomeException ())
    cleanup

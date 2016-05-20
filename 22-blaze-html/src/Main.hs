{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified Text.Blaze.XHtml5 as H
import Text.Blaze.Html.Renderer.Pretty

type UserName = String

greet :: UserName -> H.Html
greet userName = H.docTypeHtml $ do
  H.head $
    H.title "Hello!"
  H.body $ do
    H.h1 "Tervetuloa!"
    addHr [
      H.p ("Hello " >> H.toHtml userName >> "!"),
      H.p "Mitä kuuluu?"]

addHr [] = mempty
addHr [p] = p
addHr (p:ps) = p >> H.hr >> addHr ps

main = putStrLn $ renderHtml $ greet "Charles"

{-# LANGUAGE OverloadedStrings #-}
module Html where

import Form
import Text.Digestive
import Text.Digestive.Blaze.Html5
import qualified Text.Blaze.Html5 as H

-- Perus Blaze-markuppia, eli siis jonkinverran tyypitetty HTML:ää
renderForm :: View H.Html -> H.Html
renderForm v = do
  form v "POST" $ do
    H.p $ do
      label "firstName" v "Etunimi: "
      inputText "firstName" v
    H.p $ do
      label "lastName" v "Sukunimi: "
      inputText "lastName" v
    H.p $ do
      label "salary" v "Palkka?: "
      inputText "salary" v
    H.p $ do
      label "name" v "Osasto: "
      inputText "name" v
    inputSubmit "send"

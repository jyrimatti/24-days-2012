{-# LANGUAGE DeriveGeneric, OverloadedStrings #-}
module Form where

import Prelude hiding (null)
import GHC.Generics
import Data.Text
import Text.Digestive
import Data.String (IsString)

-- Ihan tavalliset Haskell-tietotyypit
data Department = Department { name :: Text } deriving (Generic, Show)
type Money = Int
data Employee = Employee {
  firstName :: Text,
  lastName :: Text,
  salary :: Maybe Money,
  department :: Department
} deriving (Generic, Show)

-- Formi tehdään muualtakin (ainakin Aeson) tutulla syntaksilla.
-- Itseäni hämää että pakollinen kenttä tulee tyhjänä stringinä jos puuttuu, eli niissäkin oli pakko lisätä explisiittinen validointi...
-- Tässä voisi vielä kokeilla paljon muutakin, kuten hienompaa validointia, custom-tyyppejä, listoja...
myform :: (Monoid v, IsString v, Monad m) => Form v m Employee
myform = Employee
             <$> "firstName" .: check "Etunimi puuttuu" (not . null) (text Nothing)
             <*> "lastName" .: check "Sukunimi puuttuu" (not . null) (text Nothing)
             <*> "salary" .: optionalStringRead ("Virheellinen palkka") Nothing
             <*> (Department <$> "name" .: check "Osastonimi puuttuu" (not . null) (text Nothing))

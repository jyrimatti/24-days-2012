module Main where

import Database.HaskellDB
import Database.HaskellDB.HDBRec
import Database.HaskellDB.DBLayout
import Database.HaskellDB.PrintQuery

data PresentName = PresentName

instance FieldTag PresentName where
  fieldName = const "name"

presentName :: Attr PresentName String
presentName = mkAttr PresentName


data ChildName = ChildName

instance FieldTag ChildName where
  fieldName = const "name"

childName :: Attr ChildName String
childName = mkAttr ChildName


data ChildLocationLat = ChildLocationLat

instance FieldTag ChildLocationLat where
  fieldName = const "loc_lat"

childLocLat :: Attr ChildLocationLat Double
childLocLat = mkAttr ChildLocationLat


data ChildLocationLong = ChildLocationLong

instance FieldTag ChildLocationLong where
  fieldName = const "loc_long"

childLocLong :: Attr ChildLocationLong Double
childLocLong = mkAttr ChildLocationLong

child :: Table (RecCons ChildName (Expr String)
               (RecCons ChildLocationLat (Expr Double)
               (RecCons ChildLocationLong (Expr Double)
                RecNil)))
child = baseTable "child"
          $ hdbMakeEntry ChildName
          # hdbMakeEntry ChildLocationLat
          # hdbMakeEntry ChildLocationLong

present :: Table (RecCons PresentName (Expr String)
                 (RecCons ChildName (Expr String)
                  RecNil))
present = baseTable "present" $ hdbMakeEntry PresentName
                              # hdbMakeEntry ChildName

allPresents :: Query (Rel (RecCons PresentName (Expr String)
                           RecNil))
allPresents = do
  allPresents <- table present
  project $ presentName << allPresents ! presentName

presentsFor :: String
            -> Query (Rel (RecCons PresentName (Expr String)
                           RecNil))
presentsFor name = do
  children <- table child
  presents <- table present
  restrict $ children ! childName .==. presents ! childName
  restrict $ children ! childName .==. constant name
  project $ presentName << presents ! presentName

main = print . ppSql . presentsFor $ "Little Bobby Tables"

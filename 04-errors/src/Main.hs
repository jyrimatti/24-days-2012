{-# LANGUAGE ScopedTypeVariables #-}
module Main where

import Control.Error
import Control.Exception
import Control.Monad
import Control.Monad.IO.Class
import Control.Monad.Trans.Either hiding (hoistEither)
import qualified Control.Monad.Trans.Either as E
import System.Environment
import System.IO.Error
import Data.Bifunctor


main :: IO ()
main = main3

-- scripti joka failaa vain tyyppiturvallisesti. Eli ei "poikkeuksia".
-- Virheinä tässä Stringejä mutta voisi kait olla esim oma tietotyyppi kunhan ei käytä valmista Script-tyyppiä.

-- "Perus do-notaatio-versio"
main1 = runScript $ do
  args <- scriptIO getArgs
  n <- tryHead "Käyttö: cabal run linenumber <filename>" args
  lueRivi =<< (readMay n) ?? "Piti olla kokonaisluku"

-- funktiokompositiota hyödyntävä versio, eli ilman do-syntaksia
main2 = runScript $ scriptIO getArgs >>= (
                    tryHead "Käyttö: cabal run linenumber <filename>"
                >=> failWith "Piti olla kokonaisluku" . readMay
                >=> lueRivi)

lueRivi :: Int -> Script ()
lueRivi ln = do
    filename <- hoistEither =<< note "Anna tiedostonimi tokana argumenttina" . headMay . tail <$> scriptIO getArgs
    res <- (scriptIO $ readFile filename) >>= (\x -> tryAt ("Rivinumeroa " ++ show ln ++ " ei ole!") (lines x) ln)
    scriptIO $ putStrLn res



-- koitetaan virheiden tyypitystä:

data Virhe = TiedostoTokanaArgumenttina | RivinumeroaEiOle Int | OltavaKokonaisluku String | VirheellinenKaytto | IOVirhe String
instance Show Virhe where
  show TiedostoTokanaArgumenttina = "Anna tiedostonimi tokana argumenttina" 
  show (RivinumeroaEiOle n)       = "Rivinumeroa " ++ show n ++ " ei ole!"
  show (OltavaKokonaisluku str)   = "Piti olla kokonaisluku: " ++ str
  show VirheellinenKaytto         = "Käyttö: cabal run linenumber <filename>"
  show (IOVirhe str)              = "IO-virhe: " ++ str

main3 = do
  res <- app
  case res of
    Left err -> print err
    Right v -> return v

app = runExceptT $ liftIO getArgs >>= (
                    tryHead VirheellinenKaytto
                >=> (\str -> failWith (OltavaKokonaisluku str) . readMay $ str)
                >=> lueRivi3)

lueRivi3 :: Int -> ExceptT Virhe IO ()
lueRivi3 ln = do
    filename <- hoistEither =<< note TiedostoTokanaArgumenttina . headMay . tail <$> liftIO getArgs
    res <- safeReadFile filename >>= (\x -> tryAt (RivinumeroaEiOle ln) (lines x) ln)
    liftIO $ putStrLn res
  where
    safeReadFile = withExceptT (IOVirhe . ioeGetErrorString) . tryIO . readFile

main4 = do
  res <- app2
  case res of
    Left err -> print err
    Right v -> return v

app2 = runEitherT $ liftIO getArgs >>= (
                    E.hoistEither . headErr VirheellinenKaytto
                >=> (\str -> E.hoistEither . readErr (OltavaKokonaisluku str) $ str)
                >=> lueRivi4)

lueRivi4 :: Int -> EitherT Virhe IO ()
lueRivi4 ln = do
    filename <- EitherT $ headErr TiedostoTokanaArgumenttina . tail <$> getArgs
    res <- safeReadFile filename >>= (\x -> E.hoistEither $ atErr (RivinumeroaEiOle ln) (lines x) ln)
    liftIO $ putStrLn res
  where
    safeReadFile = bimapEitherT (IOVirhe . ioeGetErrorString) id . tryIO . readFile
    tryIO = EitherT . liftIO . try

-- ja vielä edellinen ilman do-notaatiota
lueRivi5 :: Int -> EitherT Virhe IO ()
lueRivi5 ln = liftIO getArgs >>= (
              E.hoistEither . headErr TiedostoTokanaArgumenttina . tail
          >=> safeReadFile
          >=> return . lines
          >=> E.hoistEither . flip (atErr (RivinumeroaEiOle ln)) ln
          >=> liftIO . putStrLn)
  where
    safeReadFile = bimapEitherT (IOVirhe . ioeGetErrorString) id . tryIO . readFile
    tryIO = EitherT . liftIO . try


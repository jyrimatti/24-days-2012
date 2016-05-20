module Main where

import Options.Applicative
import Data.Char (toUpper)


-- Tietorakenteet.
-- Tässä on yksi globaali valinta (Verbosity) sekä kaksi Commandia joille molemmille omat valinnat:

data GreetOptions = GreetOptions {
    appGreet :: String
  , age :: Maybe Int
  , appSuperExcited :: Bool
  , appSurname :: Maybe String
  }

data HaistatusOptions = HaistatusOptions String

-- globaali flägi
data Verbosity = Normal | Verbose

-- komento on joko tervehdys tai haistatus
data Command = Greet GreetOptions | Haistatus HaistatusOptions

-- kokonaisuus koostuu siis yhdestä globaalista valinnasta ja jommasta kummasta komennosta valintoineen
data Options = Options {verbosity :: Verbosity, commandOpts :: Command}


-- Parserit:
-- Nämä noudattavat perus-applikatiivista syntaksia, eli
-- rakenne on kuten datatyypin rakenne mutta parametrit erotettu <$> ja <*> operaattoreilla, ja
-- datan sijaan parametrit ovat parsereita.

greetParser = Greet <$> (GreetOptions
  <$> argument str (metavar "NAME")
  <*> optional (argument auto (metavar "AGE"))
  <*> switch (short 'e' <>
              long "excited" <>
              help "Run in excited mode")
  <*> optional (strOption (short 's' <>
                           long "surname" <>
                           metavar "SURNAME" <>
                           help "Sukunimi")))

haistatusParser = Haistatus <$> (HaistatusOptions <$> argument str (metavar "WORD"))

-- kokonaisuuden parseri, jossa siis globaali flägi ja sitten aliparsereina commandit.
-- Helper-mollukka tekee näihin help-tekstit.
parser = Options
  <$> flag Normal Verbose (short 'v' <>
                           long "verbose" <>
                           help "Verbosity")
  <*> subparser (
         command "greet" (info (helper <*> greetParser) ( progDesc "Print a greeting!" ))
      <> command "haistatus" (info (helper <*> haistatusParser) ( progDesc "Print a curse!" ))
      )



-- Toiminnallisuudet:
-- Näissä ei enää näy optparse-applicative mitenkään, vaan tämä on puhdasta sovelluslogiikkaa.

greet :: GreetOptions -> IO ()
greet (GreetOptions name age excited surname) = putStrLn $ transform $ "Merry Christmas, " ++ name ++ "!"
  where
    transform = if excited then map toUpper else id

haistatus :: HaistatusOptions -> IO ()
haistatus (HaistatusOptions word) = putStrLn $ "You " ++ word ++ "!"

-- päätoiminnallisuus. Ohjaa suorituksen valitulle komennolle. Ei mitään ihmeellistä.
run (Options verbosity (Greet go))     = greet go
run (Options verbosity (Haistatus ho)) = haistatus ho



main :: IO ()
main = do
  -- tässä siis parametrien parsinta, eli optparse-applicative-osuus:
  parsed <- execParser $ info (helper <*> parser) ( fullDesc <> progDesc "Testaillaan moikkailua." <> header "Testisofta: optparse-applicative" )
   
  -- ja tässä varsinainen ohjelman suoritus, eli tavallista Haskellia:
  run parsed

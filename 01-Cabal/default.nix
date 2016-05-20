{ mkDerivation, base, bytestring, cassava, statistics, stdenv, text
}:
mkDerivation {
  pname = "x01-Cabal";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base bytestring cassava statistics text
  ];
  executableHaskellDepends = [ base ];
  description = "Solitan Haskell-harrastajien tutkailuprojekti";
  license = stdenv.lib.licenses.mit;
}

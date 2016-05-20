{ mkDerivation, base, postgresql-simple, stdenv, transformers }:
mkDerivation {
  pname = "x20-transformers";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base postgresql-simple transformers ];
  license = stdenv.lib.licenses.mit;
}

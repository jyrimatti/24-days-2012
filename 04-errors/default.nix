{ mkDerivation, base, either, errors, stdenv, transformers }:
mkDerivation {
  pname = "x04-errors";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base either errors transformers ];
  license = stdenv.lib.licenses.mit;
}

{ mkDerivation, base, pipes, stdenv, transformers }:
mkDerivation {
  pname = "x16-pipes";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base pipes transformers ];
  license = stdenv.lib.licenses.mit;
}

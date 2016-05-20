{ mkDerivation, base, parsec, stdenv }:
mkDerivation {
  pname = "x10-parsec";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base parsec ];
  license = stdenv.lib.licenses.mit;
}

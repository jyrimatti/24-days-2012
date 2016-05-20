{ mkDerivation, base, containers, random, stdenv }:
mkDerivation {
  pname = "x06-containers";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base containers random ];
  license = stdenv.lib.licenses.mit;
}

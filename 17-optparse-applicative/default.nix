{ mkDerivation, base, optparse-applicative, stdenv }:
mkDerivation {
  pname = "x17-optparse-applicative";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base optparse-applicative ];
  license = stdenv.lib.licenses.mit;
}

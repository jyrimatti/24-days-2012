{ mkDerivation, base, QuickCheck, stdenv }:
mkDerivation {
  pname = "x08-QuickCheck";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base QuickCheck ];
  license = stdenv.lib.licenses.mit;
}

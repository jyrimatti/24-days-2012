{ mkDerivation, base, haskelldb, stdenv }:
mkDerivation {
  pname = "x15-haskelldb";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base haskelldb ];
  license = stdenv.lib.licenses.mit;
}

{ mkDerivation, base, dlist, stdenv }:
mkDerivation {
  pname = "x14-dlist";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base dlist ];
  license = stdenv.lib.licenses.mit;
}

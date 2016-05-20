{ mkDerivation, base, lens, stdenv }:
mkDerivation {
  pname = "x09-lens";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base lens ];
  license = stdenv.lib.licenses.mit;
}

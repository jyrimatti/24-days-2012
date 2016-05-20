{ mkDerivation, base, hlint, stdenv }:
mkDerivation {
  pname = "x05-hlint";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base hlint ];
  license = stdenv.lib.licenses.mit;
}

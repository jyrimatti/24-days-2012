{ mkDerivation, base, criterion, stdenv }:
mkDerivation {
  pname = "x18-criterion";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base criterion ];
  license = stdenv.lib.licenses.mit;
}

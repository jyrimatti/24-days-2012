{ mkDerivation, base, ekg, postgresql-simple, stdenv, text }:
mkDerivation {
  pname = "x11-ekg";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base ekg postgresql-simple text ];
  license = stdenv.lib.licenses.mit;
}

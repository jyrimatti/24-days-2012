{ mkDerivation, base, postgresql-simple, stdenv, text }:
mkDerivation {
  pname = "x03-postgresql-simple";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base postgresql-simple text ];
  license = stdenv.lib.licenses.mit;
}

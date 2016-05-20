{ mkDerivation, aeson, base, bytestring, stdenv, text }:
mkDerivation {
  pname = "x07-aeson";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ aeson base bytestring text ];
  license = stdenv.lib.licenses.mit;
}

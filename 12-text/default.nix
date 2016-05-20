{ mkDerivation, base, bytestring, stdenv, text, text-icu }:
mkDerivation {
  pname = "x12-text";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base bytestring text text-icu ];
  license = stdenv.lib.licenses.mit;
}

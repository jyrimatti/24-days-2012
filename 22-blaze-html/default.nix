{ mkDerivation, base, blaze-html, stdenv }:
mkDerivation {
  pname = "x22-blaze-html";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base blaze-html ];
  license = stdenv.lib.licenses.mit;
}

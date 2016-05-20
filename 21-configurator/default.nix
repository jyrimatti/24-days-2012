{ mkDerivation, base, configurator, stdenv }:
mkDerivation {
  pname = "x21-configurator";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base configurator ];
  license = stdenv.lib.licenses.mit;
}

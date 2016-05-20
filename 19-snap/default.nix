{ mkDerivation, base, lens, snap, snap-core
, snaplet-postgresql-simple, stdenv
}:
mkDerivation {
  pname = "x19-snap";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base lens snap snap-core snaplet-postgresql-simple
  ];
  license = stdenv.lib.licenses.mit;
}

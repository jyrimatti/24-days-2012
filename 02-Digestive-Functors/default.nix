{ mkDerivation, aeson, attoparsec, base, blaze-html, bytestring
, digestive-functors, digestive-functors-aeson
, digestive-functors-blaze, digestive-functors-snap, lens, snap
, snap-blaze-clay, snap-server, stdenv, text
}:
mkDerivation {
  pname = "x02-Digestive-Functors";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson attoparsec base blaze-html bytestring digestive-functors
    digestive-functors-aeson digestive-functors-blaze
    digestive-functors-snap lens snap snap-blaze-clay snap-server text
  ];
  license = stdenv.lib.licenses.mit;
}

{
  lib,
  fetchurl,
  stdenvNoCC,
  undmg,
}:
stdenvNoCC.mkDerivation rec {
  pname = "Transmission";
  version = "4.1.1";

  src = fetchurl {
    url = "https://github.com/transmission/transmission/releases/download/${version}/Transmission-${version}.dmg";
    sha256 = "sha256-dEQp2nLLLFeWTyC3i4PXX07L08aM55rv2gim6Ng8eTA=";
  };

  nativeBuildInputs = [undmg];

  sourceRoot = "Transmission.app";

  installPhase = ''
    mkdir -p "$out/Applications/${sourceRoot}"
    cp -R . "$out/Applications/${sourceRoot}"
  '';

  meta = {
    description = "BitTorrent Client";
    homepage = "https://transmissionbt.com/";
    license = with lib.licenses; [
      gpl2Plus
      mit
    ];
    platforms = lib.platforms.darwin;
  };
}

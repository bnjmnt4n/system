{ stdenv, lib, fetchurl, unzip }:

# TODO: Check for updates at:
# - https://chromiumdash.appspot.com/releases?platform=Mac.
# - https://commondatastorage.googleapis.com/chromium-browser-snapshots/index.html?prefix=Mac_Arm/

stdenv.mkDerivation rec {
  name = "Chromium";
  version = "1204193"; # 119.0.6045.0

  buildInputs = [ unzip ];
  sourceRoot = "chrome-mac";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p $out/Applications
    cp -r Chromium.app $out/Applications/Chromium.app
  '';

  src = fetchurl {
    url = "https://commondatastorage.googleapis.com/chromium-browser-snapshots/Mac_Arm/${version}/chrome-mac.zip";
    sha256 = "sha256-wi+pPDpI/YBXGUwcTBxtHiPasPrBu1oCT2+jdpFe41E=";
  };

  meta = with lib; {
    description = "Chromium web browser";
    homepage = "https://chromium.org";
    platforms = platforms.darwin;
  };
}

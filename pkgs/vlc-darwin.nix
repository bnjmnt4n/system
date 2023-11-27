{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "vlc";
  version = "3.0.20";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r VLC.app "$out/Applications/VLC.app"
  '';

  src = fetchurl {
    url = "https://get.videolan.org/vlc/${version}/macosx/vlc-${version}-arm64.dmg";
    sha256 = "sha256-XV8O5S2BmCpiL0AhkopktHBalVRJniDDPQusIlkLEY4=";
  };

  meta = with lib; {
    description = "Cross-platform media player and streaming server";
    homepage = "https://www.videolan.org/vlc/";
    platforms = platforms.darwin;
  };
}

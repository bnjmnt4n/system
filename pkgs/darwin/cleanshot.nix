{ lib, fetchurl, stdenvNoCC }:

let
  hdiutil = "/usr/bin/hdiutil";

in
stdenvNoCC.mkDerivation rec {
  pname = "cleanshot";
  version = "4.7.3";

  src = fetchurl {
    url = "https://updates.getcleanshot.com/v3/CleanShot-X-${version}.dmg";
    sha256 = "sha256-1w8yl2+MWFjjmu1LyX6vzCNJD8KYJ4IL/uqmLdrFOCU=";
  };

  sourceRoot = "CleanShot X.app";

  unpackPhase = ''
    mkdir -p ./Applications
    ${hdiutil} attach -readonly -mountpoint mnt $src
    cp -r "mnt/${sourceRoot}" .
    ${hdiutil} detach -force mnt
  '';

  installPhase = ''
    mkdir -p "$out/Applications/${sourceRoot}"
    cp -R . "$out/Applications/${sourceRoot}"
  '';

  meta = {
    description = "Screen capturing tool";
    homepage = "https://cleanshot.com/";
    platforms = lib.platforms.darwin;
  };
}

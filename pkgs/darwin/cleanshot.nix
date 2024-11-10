{ lib, fetchurl, stdenvNoCC }:

let
  hdiutil = "/usr/bin/hdiutil";

in
stdenvNoCC.mkDerivation rec {
  pname = "Cleanshot X";
  version = "4.7.4";

  src = fetchurl {
    url = "https://updates.getcleanshot.com/v3/CleanShot-X-${version}.dmg";
    sha256 = "sha256-EemNNJ5+ULWFMp7Sn81W6Tvne4rKdNtfTB5P4wnXpaA=";
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

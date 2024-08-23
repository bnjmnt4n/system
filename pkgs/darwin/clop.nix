{ lib, fetchurl, stdenvNoCC }:

let
  hdiutil = "/usr/bin/hdiutil";
in
stdenvNoCC.mkDerivation rec {
  pname = "clop";
  version = "2.5.5";

  src = fetchurl {
    url = "https://github.com/FuzzyIdeas/Clop/releases/download/v${version}/Clop-${version}.dmg";
    sha256 = "sha256-iooXDzp9EKdJU2fFWlf4BExNo/Dy5D7TvVq9nLca2P8=";
  };

  sourceRoot = "Clop.app";

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
    homepage = "https://lowtechguys.com/clop/";
    description = "Clipboard optimizer for macOS";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.darwin;
  };
}

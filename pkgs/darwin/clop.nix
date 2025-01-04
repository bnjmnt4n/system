{
  lib,
  fetchurl,
  stdenvNoCC,
}: let
  hdiutil = "/usr/bin/hdiutil";
in
  stdenvNoCC.mkDerivation rec {
    pname = "Clop";
    version = "2.6.3";

    src = fetchurl {
      url = "https://github.com/FuzzyIdeas/Clop/releases/download/v${version}/Clop-${version}.dmg";
      sha256 = "sha256-R7h4XDVLAMj2XzhQsBxHi1gHg3CJKjizvSZKP/d6QAQ=";
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

{
  lib,
  fetchurl,
  stdenvNoCC,
}: let
  hdiutil = "/usr/bin/hdiutil";
in
  stdenvNoCC.mkDerivation rec {
    pname = "Cleanshot X";
    version = "4.7.6";

    src = fetchurl {
      url = "https://updates.getcleanshot.com/v3/CleanShot-X-${version}.dmg";
      sha256 = "sha256-Z3F4uAYMXj1XnVpTR5LCuWScg1sdB6owfxiiinMwe1U=";
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

{ lib, fetchurl, stdenvNoCC }:

let
  hdiutil = "/usr/bin/hdiutil";
in
stdenvNoCC.mkDerivation rec {
  pname = "Zed";
  version = "0.149.3";

  src = fetchurl {
    url = "https://zed.dev/api/releases/stable/${version}/Zed.dmg";
    sha256 = "sha256-BlpvN3jEzQiKSR4Jj6JmvlPYcPdJu37HCiK/bJKz69c=";
  };

  sourceRoot = "Zed.app";

  unpackPhase = ''
    mkdir -p ./Applications
    ${hdiutil} attach -mountpoint mnt $src
    cp -r "mnt/${sourceRoot}" .
    ${hdiutil} detach -force mnt
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/Applications/${sourceRoot}"
    cp -R . "$out/Applications/${sourceRoot}"
    ln -fs "$out/Applications/${sourceRoot}/Contents/MacOS/cli" $out/bin/zed
  '';

  meta = {
    description = "Multiplayer code editor";
    homepage = "https://zed.dev/";
    platforms = lib.platforms.darwin;
  };
}

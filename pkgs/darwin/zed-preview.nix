{ lib, fetchurl, stdenvNoCC }:

let
  hdiutil = "/usr/bin/hdiutil";
in
stdenvNoCC.mkDerivation rec {
  pname = "Zed Preview";
  version = "0.156.0";

  src = fetchurl {
    url = "https://zed.dev/api/releases/preview/${version}/Zed.dmg";
    sha256 = "sha256-ESirDBj5vLfPDdnSbxHZNsJCRFQm08wLd+UBIwwjVxM=";
  };

  sourceRoot = "Zed Preview.app";

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

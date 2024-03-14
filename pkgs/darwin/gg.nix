{ lib, fetchurl, stdenvNoCC }:

let
  hdiutil = "/usr/bin/hdiutil";
in
stdenvNoCC.mkDerivation rec {
  pname = "gg";
  version = "0.15.2";

  src = fetchurl {
    url = "https://github.com/gulbanana/gg/releases/download/v${version}/gg_${version}_universal.dmg";
    sha256 = "sha256-/HX1yCjhSAbpq829fg33XMvYw+U0DmZ8E63fLzoQg7A=";
  };

  sourceRoot = "gg.app";

  unpackPhase = ''
    mkdir -p ./Applications
    ${hdiutil} attach -readonly -mountpoint mnt $src
    cp -r "mnt/${sourceRoot}" .
    ${hdiutil} detach -force mnt
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/Applications/${sourceRoot}"
    cp -R . "$out/Applications/${sourceRoot}"
    ln -fs "$out/Applications/${sourceRoot}/Contents/MacOS/gg" $out/bin/gg
  '';

  meta = {
    homepage = "https://github.com/gulbanana/gg";
    description = "GUI for jj";
    license = lib.licenses.asl20;
    platforms = lib.platforms.darwin;
  };
}

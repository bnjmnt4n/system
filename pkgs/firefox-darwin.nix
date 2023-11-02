{ stdenv, lib, fetchurl, undmg }:

# Based on https://cmacr.ae/blog/managing-firefox-on-macos-with-nix/.
# TODO: remove when https://github.com/NixOS/nixpkgs/pull/194908 is merged.

stdenv.mkDerivation rec {
  pname = "Firefox";
  version = "119.0";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
      mkdir -p "$out/Applications"
      cp -r Firefox.app "$out/Applications/Firefox.app"
    '';

  src = fetchurl {
    name = "Firefox-${version}.dmg";
    url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/mac/en-GB/Firefox%20${version}.dmg";
    sha256 = "sha256-OwyKis1T1HzCBS1UF/d74YBvD1TEqyxvy0oUvvKb0Fo=";
  };

  meta = with lib; {
    description = "The Firefox web browser";
    homepage = "https://www.mozilla.org/en-GB/firefox";
    platforms = platforms.darwin;
  };
}

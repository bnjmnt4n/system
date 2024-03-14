{ src, lib, stdenv, fetchurl }:

# TODO: Build manually.

stdenv.mkDerivation rec {
  name = "dark-notify";
  version = "0.1.2";

  src = fetchurl {
    url = "https://github.com/cormacrelf/dark-notify/releases/download/v${version}/dark-notify-v0.1.2.tar.gz";
    sha256 = "987c4e40ca9f7996f72d8967a74417e2fc7e8d7aea02e93bd314f80a80817f9a";
  };

  sourceRoot = ".";
  installPhase = ''
    mkdir -p $out/bin
    mv dark-notify $out/bin/dark-notify
  '';

  meta = {
    description = "Watcher for macOS 10.14+ light/dark mode changes";
    homepage = "https://github.com/cormacrelf/dark-notify";
    platforms = lib.platforms.all;
  };
}

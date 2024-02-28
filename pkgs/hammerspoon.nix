{ lib, stdenvNoCC, fetchurl, unzip }:

stdenvNoCC.mkDerivation rec {
  pname = "Hammerspoon";
  version = "0.9.100";

  src = fetchurl {
    url = "https://github.com/Hammerspoon/hammerspoon/releases/download/${version}/Hammerspoon-${version}.zip";
    sha256 = "sha256-bc/IB8fOxpLK87GMNsweo69rn0Jpm03yd3NECOTgc5k=";
  };

  sourceRoot = "Hammerspoon.app";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p "$out/Applications/${sourceRoot}"
    mkdir -p $out/bin
    cp -R . "$out/Applications/${sourceRoot}"
    ln -fs "$out/Applications/${sourceRoot}/Contents/Frameworks/hs/hs" "$out/bin/hs"
  '';

  meta = {
    description = "Staggeringly powerful macOS desktop automation with Lua.";
    homepage = "https://www.hammerspoon.org";
    platforms = lib.platforms.darwin;
  };
}

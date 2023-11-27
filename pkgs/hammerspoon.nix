{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "Hammerspoon";
  version = "0.9.100";

  src = fetchzip {
    url = "https://github.com/Hammerspoon/hammerspoon/releases/download/${version}/Hammerspoon-${version}.zip";
    sha256 = "Q14NBizKz7LysEFUTjUHCUnVd6+qEYPSgWwrOGeT9Q0=";
  };

  installPhase = ''
    mkdir -p $out/Applications/Hammerspoon.app
    mkdir -p $out/bin
    mv ./* $out/Applications/Hammerspoon.app
    chmod +x "$out/Applications/Hammerspoon.app/Contents/MacOS/Hammerspoon"
    ln -fs $out/Applications/Hammerspoon.app/Contents/Frameworks/hs/hs $out/bin/hs
  '';

  meta = with lib; {
    description = "Staggeringly powerful macOS desktop automation with Lua.";
    homepage = "https://www.hammerspoon.org";
    platforms = platforms.darwin;
  };
}

{ stdenv, lib, fetchurl, undmg }:

# TODO: error: only HFS file systems are supported.

stdenv.mkDerivation rec {
  pname = "Zed";
  version = "0.113.0";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Zed.app "$out/Applications/Zed.app"
    ln -fs $out/Applications/Zed.app/Contents/MacOS/cli $out/bin/zed
  '';

  src = fetchurl {
    url = "https://zed.dev/api/releases/stable/${version}/Zed.dmg";
    sha256 = "sha256-EVTupYCVWHhJOD7XP7d5XkIDW+fysMKdfr4UNkzZRe8=";
  };

  meta = with lib; {
    description = "Multiplayer code editor";
    homepage = "https://zed.dev/";
    platforms = platforms.darwin;
  };
}

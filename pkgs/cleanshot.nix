{
  lib,
  fetchurl,
  stdenvNoCC,
  _7zz,
}:
stdenvNoCC.mkDerivation rec {
  pname = "Cleanshot X";
  version = "4.7.6";

  src = fetchurl {
    url = "https://updates.getcleanshot.com/v3/CleanShot-X-${version}.dmg";
    sha256 = "sha256-Z3F4uAYMXj1XnVpTR5LCuWScg1sdB6owfxiiinMwe1U=";
  };

  nativeBuildInputs = [_7zz];

  sourceRoot = "CleanShot X.app";

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

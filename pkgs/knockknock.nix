{
  lib,
  fetchurl,
  stdenvNoCC,
  unzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "KnockKnock";
  version = "4.0.3";

  src = fetchurl {
    url = "https://github.com/objective-see/KnockKnock/releases/download/v${version}/KnockKnock_${version}.zip";
    sha256 = "sha256-HhNx/262LghmJmoHROkKo73GsizKBZmvvTMN31JmPGk=";
  };

  nativeBuildInputs = [unzip];

  sourceRoot = "KnockKnock.app";

  installPhase = ''
    mkdir -p "$out/Applications/${sourceRoot}"
    cp -R . "$out/Applications/${sourceRoot}"
  '';

  meta = {
    description = "Enumerate persistently installed software";
    homepage = "https://github.com/objective-see/KnockKnock";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.darwin;
  };
}

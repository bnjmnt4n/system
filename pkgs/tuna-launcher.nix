{
  lib,
  fetchurl,
  stdenvNoCC,
  unzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "Tuna";
  version = "0.75";

  src = fetchurl {
    url = "https://tunaformac.com/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MjE4LCJwdXIiOiJibG9iX2lkIn19--5b02bc933dcb6b02d012f986a4a9f05f7171a0b0/Tuna-0.76-1488.zip";
    sha256 = "sha256-ZnBm7oYehrdXj0vjFY3Jz2Zcw7wAcUaou4/gcpPrdFQ=";
  };

  nativeBuildInputs = [unzip];

  sourceRoot = "Tuna.app";

  installPhase = ''
    mkdir -p "$out/Applications/${sourceRoot}"
    cp -R . "$out/Applications/${sourceRoot}"
  '';

  meta = {
    description = "Launcher for macOS";
    homepage = "https://tunaformac.com/";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
  };
}

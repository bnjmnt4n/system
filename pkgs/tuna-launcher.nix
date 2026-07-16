{
  lib,
  fetchurl,
  stdenvNoCC,
  unzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "Tuna";
  version = "0.78";

  src = fetchurl {
    url = "https://tunaformac.com/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MjI0LCJwdXIiOiJibG9iX2lkIn19--99b6e9db4b1fd8d74a1b134705fe6adfa11f4e95/Tuna-0.78-1563.zip";
    sha256 = "sha256-+zeDaNNPbUGb+QhyeDHbtaaKSXiQ2FfIf1tpJDL8CXA=";
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

{
  lib,
  fetchurl,
  stdenvNoCC,
  unzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "secretive";
  version = "2.4.1";

  src = fetchurl {
    url = "https://github.com/maxgoedjen/secretive/releases/download/v${version}/Secretive.zip";
    hash = "sha256-AN32UfEVHx44iMUeWM40P2iISA23l3G23nNx2yG95Ng=";
  };

  sourceRoot = "Secretive.app";

  nativeBuildInputs = [unzip];

  installPhase = ''
    mkdir -p "$out/Applications/${sourceRoot}"
    cp -R . "$out/Applications/${sourceRoot}"
  '';

  meta = {
    description = "Store SSH keys in the Secure Enclave";
    homepage = "https://github.com/maxgoedjen/secretive";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
  };
}

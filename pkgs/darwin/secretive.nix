{
  lib,
  fetchurl,
  stdenvNoCC,
  unzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "secretive";
  version = "3.0.2";

  src = fetchurl {
    url = "https://github.com/maxgoedjen/secretive/releases/download/v${version}/Secretive.zip";
    hash = "sha256-A7K3yBv8PgYaoFQoNfA069hh13+PMpi8waxdvR7S1N0=";
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

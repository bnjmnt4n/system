{
  lib,
  fetchurl,
  stdenvNoCC,
  unzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "secretive";
  version = "3.0.3";

  src = fetchurl {
    url = "https://github.com/maxgoedjen/secretive/releases/download/v${version}/Secretive.zip";
    hash = "sha256-q4p9a1kLMxP3uzg7iB+0CtH/5KuEhYDpsIiZs+YMMj0=";
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

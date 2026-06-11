{
  lib,
  fetchurl,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "ImageOptim";
  version = "1.9.3";

  src = fetchurl {
    url = "https://imageoptim.com/ImageOptim${version}.tar.xz";
    sha256 = "sha256-1ORTu7VbZJHVGaMODm3lvrfOGpKej4NXZ7Y472/9Nx0=";
  };

  nativeBuildInputs = [];

  sourceRoot = "ImageOptim.app";

  installPhase = ''
    mkdir -p "$out/Applications/${sourceRoot}"
    cp -R . "$out/Applications/${sourceRoot}"
  '';

  meta = {
    homepage = "https://imageoptim.com/mac";
    description = "Tool to optimise images to a smaller size";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.darwin;
  };
}

{
  lib,
  fetchurl,
  stdenvNoCC,
  _7zz,
}:
stdenvNoCC.mkDerivation rec {
  pname = "Clop";
  version = "2.11.6";

  src = fetchurl {
    url = "https://github.com/FuzzyIdeas/Clop/releases/download/v${version}/Clop-${version}.dmg";
    sha256 = "sha256-/4CWJKLarboN0c+7NKNmzag4i1YAg3TJsZCnaJEEom4=";
  };

  nativeBuildInputs = [_7zz];

  sourceRoot = "Clop.app";

  installPhase = ''
    mkdir -p "$out/Applications/${sourceRoot}"
    cp -R . "$out/Applications/${sourceRoot}"
  '';

  meta = {
    homepage = "https://lowtechguys.com/clop/";
    description = "Clipboard optimizer for macOS";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.darwin;
  };
}

{ lib
, stdenvNoCC
, fetchurl
, undmg
, unzip
, makeWrapper
}:

stdenvNoCC.mkDerivation rec {
  pname = "neovide-bin";
  version = "0.12.0";

  src = fetchurl {
    url = "https://github.com/neovide/neovide/releases/download/${version}/Neovide.dmg.zip";
    sha256 = "sha256-PrnQSHswqWYlHr3kwKaP1lyhGyoOrtf7Hbp52GbO2G4=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ makeWrapper unzip undmg ];

  sourceRoot = "Neovide.app";

  unpackPhase = ''
    ${unzip}/bin/unzip $src -d $TMPDIR
    /usr/bin/hdiutil mount $TMPDIR/Neovide.dmg
    cp -R /Volumes/Neovide/Neovide.app .
    /usr/bin/hdiutil unmount /Volumes/Neovide
    rm -r $TMPDIR/Neovide.dmg
  '';

  installPhase = ''
    mkdir -p $out/{Applications/Neovide.app,bin}
    cp -R . $out/Applications/Neovide.app
    makeWrapper $out/Applications/Neovide.app/Contents/MacOS/neovide $out/bin/neovide
  '';

  meta = with lib; {
    description = "No Nonsense Neovim Client in Rust";
    homepage = "https://neovide.dev";
    license = with licenses; [ mit ];
    mainProgram = "neovide";
    platforms = platforms.darwin;
  };
}

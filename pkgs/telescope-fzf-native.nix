{
  pkgs,
  src,
}:
pkgs.stdenv.mkDerivation {
  name = "telescope-fzf-native";
  src = src;
  installPhase = ''
    mkdir -p $out
    cp -r lua build $out
  '';
}

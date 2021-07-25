{ pkgs, src }:

pkgs.stdenv.mkDerivation {
  name = "telescope-fzf-native";
  installPhase = ''
    mkdir -p $out/build
    cp build/libfzf.so $out/build/libfzf.so
  '';
  src = src;
}

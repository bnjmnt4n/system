{ pkgs, src }:

pkgs.stdenv.mkDerivation {
  name = "socprint";
  version = src.rev;
  installPhase = ''
    mkdir -p $out/bin
    cp socprint.sh $out/bin/socprint
  '';
  inherit src;
}

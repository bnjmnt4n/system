{ pkgs, src }:

pkgs.stdenv.mkDerivation {
  name = "socprint";
  version = src.rev;
  installPhase = ''
    mkdir -p $out/bin
    cp socprint.sh $out/bin/socprint
  '';
  patches = [
    ./0001-Update-to-use-stu.comp.nus.edu.sg-as-host.patch
  ];
  inherit src;
}

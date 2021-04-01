{ config, lib, pkgs, ... }:

{
  imports = [
    ../../home/base.nix
    ../../home/graphical.nix
  ];

  # TODO: remove?
  home.username = "bnjmnt4n";
  home.homeDirectory = "/home/bnjmnt4n";

  # Miscellaneous/temporary packages.
  home.packages = with pkgs; [
    jetbrains.idea-community
    musescore
    # octave
    openjdk11
    qtspim
    teams
    (rWrapper.override {
      packages = with rPackages; [
        Rcmdr
        RcmdrMisc
        ggpmisc
        sem
        rmarkdown
        rgl
        multcomp
        lmtest
        leaps
        aplpack
        reshape2
      ];
    })
  ];
}
